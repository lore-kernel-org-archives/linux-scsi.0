From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/3] arcmsr: Support Areca new SATA Raid Adapter ARC1214/1224/1264/1284
Date: Mon, 26 Aug 2013 14:20:58 +0200
Message-ID: <521B482A.80908@redhat.com>
References: <7A2818CC441F4BCE96D3B1E70CC3D76B@chingDT>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7A2818CC441F4BCE96D3B1E70CC3D76B@chingDT>
Sender: linux-kernel-owner@vger.kernel.org
To: =?Big5?B?tsCyTbap?= <ching2048@areca.com.tw>
Cc: james.bottomley@hansenpartnership.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, billion@areca.com.tw
List-Id: linux-scsi@vger.kernel.org

On 08/26/2013 06:14 AM, =B6=C0=B2M=B6=A9 wrote:
>  From: Ching <ching2048@areca.com.tw>
>
> Support Areca new SATA Raid adapter ARC1214/1224/1264/1284.
> Modify maximum outstanding command number, notify command complete wi=
th auto
> request sense
> Signed-off-by: Ching  <ching2048@areca.com.tw>

Hi Ching,
+static bool
+arcmsr_hbaD_get_config(struct AdapterControlBlock *acb)
+{
=2E..
+	dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->uncache_size,
+	&dma_coherent_handle, GFP_KERNEL);
+	if (!dma_coherent) {
+		pr_notice("DMA allocation failed...\n");
+		return -ENOMEM;
You've declared the return value as a bool so the function should retur=
n false or true.
---------------------------------------
In arcmsr_alloc_ccb_pool
-	roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) + (max=
_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
-	acb->uncache_size =3D roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;
-	dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->uncache_size, &d=
ma_coherent_handle, GFP_KERNEL);
-	if(!dma_coherent){
-		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error\n", acb->=
host->host_no);
-		return -ENOMEM;
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A: {
+		roundup_ccbsize =3D
+		roundup(sizeof(struct CommandControlBlock) +
+		max_sg_entrys * sizeof(struct SG64ENTRY), 32);
+		acb->uncache_size =3D roundup_ccbsize *
+			ARCMSR_MAX_FREECCB_NUM;
+		dma_coherent =3D dma_alloc_coherent(&pdev->dev,
+			acb->uncache_size, &dma_coherent_handle,
+			GFP_KERNEL);
=2E..
+	case ACB_ADAPTER_TYPE_B: {
+		roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) +
+			(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
+		acb->uncache_size =3D roundup_ccbsize *
+			ARCMSR_MAX_FREECCB_NUM;
+		dma_coherent =3D dma_alloc_coherent(&pdev->dev,
+			acb->uncache_size, &dma_coherent_handle,
+			GFP_KERNEL);
You've added a switch with  four almost identical
cases, what is the point of splitting the code this way?
-----------------------------------------
 struct AdapterControlBlock
+	void *dma_coherent;
+	dma_addr_t dma_coherent_handle;
+	dma_addr_t dma_coherent_handle2;
+	void *dma_coherent2;
why do you need these pairs? Is there an adapter which uses both
for example dma_coherent and dma_coherent2 at the same time?

Please include the patch into the message body next time, it makes the =
review easier.
Thanks, Tomas=20
=20
