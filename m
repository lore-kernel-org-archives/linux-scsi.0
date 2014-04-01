From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/4] target/rd: T10-Dif: RAM disk is allocating more
 space than required.
Date: Mon, 31 Mar 2014 17:41:59 -0700
Message-ID: <1396312919.22665.55.camel@haakon3.risingtidesystems.com>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>
	 <1396047927-14189-5-git-send-email-quinn.tran@qlogic.com>
	 <5336125F.2020000@mellanox.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46CE9A5A@avmb2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <504EB66DAC8D234EB8E8560985C2D7AD46CE9A5A@avmb2.qlogic.org>
Sender: target-devel-owner@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>
Cc: sagi grimberg <sagig@mellanox.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Hi Quinn & Co,

On Mon, 2014-03-31 at 16:15 +0000, Quinn Tran wrote:
> On 3/28/14 5:22 PM, "sagi grimberg" <sagig@mellanox.com> wrote:
> 
> >On 3/29/2014 2:05 AM, Quinn Tran wrote:
> >> Ram disk is allocating 8x more space than required for diff data.
> >> For large RAM disk test, there is small potential for memory
> >> starvation.
> >>
> >> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> >> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> >> ---
> >>   drivers/target/target_core_rd.c | 6 +++++-
> >>   1 file changed, 5 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/target/target_core_rd.c
> >>b/drivers/target/target_core_rd.c
> >> index 01dda0b..6df177a 100644
> >> --- a/drivers/target/target_core_rd.c
> >> +++ b/drivers/target/target_core_rd.c
> >> @@ -253,7 +253,11 @@ static int rd_build_prot_space(struct rd_dev
> >>*rd_dev, int prot_length)
> >>      if (rd_dev->rd_flags & RDF_NULLIO)
> >>              return 0;
> >>
> >> -    total_sg_needed = rd_dev->rd_page_count / prot_length;
> >> +    /* prot_length=8byte dif data
> >> +     * tot sg needed = rd_page_count * (PGSZ/512) * (prot_length/PGSZ) +
> >>pad
> >> +     * PGSZ canceled each other.
> >> +     */
> >> +    total_sg_needed = (rd_dev->rd_page_count * prot_length / 512) +1;
> >
> >You probably will want to use block_size instead of hard-coding 512.
> >Other then that this makes sense.
> 
> QT> agreed
> 

Applying the following updated patch to target-pending/for-next, along
with Sagi's comment wrt to block_size.

Also adding your missing Signed-off-by.  Please make sure to include
these in future patches.  ;)

Thanks!

--nab

commit 435b88ba4a38adc39842957610b27a8d0fb4584b
Author: Quinn Tran <quinn.tran@qlogic.com>
Date:   Fri Mar 28 19:05:27 2014 -0400

    target/rd: T10-Dif: RAM disk is allocating more space than required.
    
    Ram disk is allocating 8x more space than required for diff data.
    For large RAM disk test, there is small potential for memory
    starvation.
    
    (Use block_size when calculating total_sg_needed - sagi + nab)
    
    Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
    Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
    Cc: <stable@vger.kernel.org> #3.14+
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 66a5aba..b920db3 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -242,7 +242,7 @@ static void rd_release_prot_space(struct rd_dev *rd_dev)
        rd_dev->sg_prot_count = 0;
 }
 
-static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length)
+static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block_size)
 {
        struct rd_dev_sg_table *sg_table;
        u32 total_sg_needed, sg_tables;
@@ -252,8 +252,13 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length)
 
        if (rd_dev->rd_flags & RDF_NULLIO)
                return 0;
-
-       total_sg_needed = rd_dev->rd_page_count / prot_length;
+       /*
+        * prot_length=8byte dif data
+        * tot sg needed = rd_page_count * (PGSZ/block_size) *
+        *                 (prot_length/block_size) + pad
+        * PGSZ canceled each other.
+        */
+       total_sg_needed = (rd_dev->rd_page_count * prot_length / block_size) + 1;
 
        sg_tables = (total_sg_needed / max_sg_per_table) + 1;
 
@@ -606,7 +611,8 @@ static int rd_init_prot(struct se_device *dev)
         if (!dev->dev_attrib.pi_prot_type)
                return 0;
 
-       return rd_build_prot_space(rd_dev, dev->prot_length);
+       return rd_build_prot_space(rd_dev, dev->prot_length,
+                                  dev->dev_attrib.block_size);
 }
 
 static void rd_free_prot(struct se_device *dev)
