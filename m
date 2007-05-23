From: "Aubrey Li" <aubreylee@gmail.com>
Subject: Re: [PATCH] [scsi] Remove __GFP_DMA
Date: Wed, 23 May 2007 10:41:13 +0800
Message-ID: <6d6a94c50705221941y63f4db7bj174a2265d9eaa61a@mail.gmail.com>
References: <20070521151525.GA581@suse.de>
	 <Pine.LNX.4.64.0705221443030.16285@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.230]:13208 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbXEWClP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 22:41:15 -0400
Received: by nz-out-0506.google.com with SMTP id z3so54498nzf
        for <linux-scsi@vger.kernel.org>; Tue, 22 May 2007 19:41:14 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0705221443030.16285@schroedinger.engr.sgi.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Lameter <clameter@sgi.com>
Cc: Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On 5/23/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Mon, 21 May 2007, Bernhard Walle wrote:
>
> > [PATCH] [scsi] Remove __GFP_DMA
> >
> > After 821de3a27bf33f11ec878562577c586cd5f83c64, it's not necessary to alloate a
> > DMA buffer any more in sd.c.
> >
> > Signed-off-by: Bernhard Walle <bwalle@suse.de>
>
> Great that avoids a DMA kmalloc slab. Any other GFP_DMAs left in the scsi
> layer?
>
> Acked-by: Christoph Lameter <clameter@sgi.com>

Yes, here is another patch

Signed-off-by: Aubrey.Li <aubreylee@gmail.com>
---
 drivers/scsi/aacraid/commctrl.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 72b0393..405722d 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -580,8 +580,8 @@ static int aac_send_raw_srb(struct aac_dev* dev,
void __user * arg)
 			for (i = 0; i < upsg->count; i++) {
 				u64 addr;
 				void* p;
-				/* Does this really need to be GFP_DMA? */
-				p = kmalloc(upsg->sg[i].count,GFP_KERNEL|__GFP_DMA);
+
+				p = kmalloc(upsg->sg[i].count,GFP_KERNEL);
 				if(p == 0) {
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size
= %d buffer number %d of %d\n",
 					  upsg->sg[i].count,i,upsg->count));
@@ -624,8 +624,8 @@ static int aac_send_raw_srb(struct aac_dev* dev,
void __user * arg)
 			for (i = 0; i < usg->count; i++) {
 				u64 addr;
 				void* p;
-				/* Does this really need to be GFP_DMA? */
-				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
+
+				p = kmalloc(usg->sg[i].count,GFP_KERNEL);
 				if(p == 0) {
 					kfree (usg);
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size
= %d buffer number %d of %d\n",
@@ -666,8 +666,8 @@ static int aac_send_raw_srb(struct aac_dev* dev,
void __user * arg)
 			for (i = 0; i < upsg->count; i++) {
 				u64 addr;
 				void* p;
-				/* Does this really need to be GFP_DMA? */
-				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
+
+				p = kmalloc(usg->sg[i].count,GFP_KERNEL);
 				if(p == 0) {
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size
= %d buffer number %d of %d\n",
 					  usg->sg[i].count,i,usg->count));
-- 
1.5.1.1
