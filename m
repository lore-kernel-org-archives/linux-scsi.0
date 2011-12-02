From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: RE: [PATCH] SCSI: aacraid: potential integer overflow in aac_get_containers()
Date: Fri, 2 Dec 2011 08:03:29 -0800
Message-ID: <FC1F9E38C0703341A1A750524E2525A9019791E6@XYUS-EX22.xyus.xyratex.com>
References: <1322706601-26181-1-git-send-email-haogangchen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <1322706601-26181-1-git-send-email-haogangchen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Haogang Chen <haogangchen@gmail.com>, aacraid@adaptec.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NAK

I dispute that it is necessary or worth the additional abstraction,
since MAXIMUM_NUM_CONTAINERS is in the order of 32, and
sizeof(*fsa_dev_ptr) is in the range of 80 bytes ... There is a LONG
road to hoe to get to the point of overload!

kcalloc -> __kmalloc(size_t, flags | __GFP_ZERO);
kzalloc -> kmalloc(size_t, flags | __GFP_ZERO);
kmalloc -> __kmalloc(size_t, flags);

kcalloc can not allocate a larger entity than kzalloc. But alas it can
report that the size has exceeded ULONG_MAX so that part of the patch is
VERY sound.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Haogang Chen
Sent: Wednesday, November 30, 2011 9:30 PM
To: aacraid@adaptec.com
Cc: JBottomley@parallels.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; haogangchen@gmail.com
Subject: [PATCH] SCSI: aacraid: potential integer overflow in
aac_get_containers()

There is a potential integer overflow in aac_get_containers(). When
maximum_num_containers is large, the subsequent call to kzalloc() will
allocate a buffer smaller than expected, which leads to memory
corruption in the for loop.

The patch replaces kzalloc with kcalloc.

Signed-off-by: Haogang Chen <haogangchen@gmail.com>
---
 drivers/scsi/aacraid/aachba.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c
b/drivers/scsi/aacraid/aachba.c
index 409f580..440b84d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -381,7 +381,7 @@ int aac_get_containers(struct aac_dev *dev)
 
 	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
 		maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
-	fsa_dev_ptr = kzalloc(sizeof(*fsa_dev_ptr) *
maximum_num_containers,
+	fsa_dev_ptr = kcalloc(maximum_num_containers,
sizeof(*fsa_dev_ptr), 
 			GFP_KERNEL);
 	if (!fsa_dev_ptr)
 		return -ENOMEM;
-- 
1.7.5.4
