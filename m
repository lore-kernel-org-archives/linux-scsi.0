From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH] SCSI, Brocade FC HBA: Remember to always
 release_firmware() so we don't leak memory.
Date: Sat, 15 Jan 2011 15:24:06 -0800
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A5D390937D@HQ1-EXCH01.corp.brocade.com>
References: <alpine.LNX.2.00.1101122306480.27008@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1101122306480.27008@swampdragon.chaosbits.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

Thanks for fixing the issue. The patch looks good to me.

Acked-by: Jing Huang <huangj@brocade.com>

>-----Original Message-----
>From: Jesper Juhl [mailto:jj@chaosbits.net]
>Sent: Wednesday, January 12, 2011 2:10 PM
>To: linux-kernel@vger.kernel.org
>Cc: linux-scsi@vger.kernel.org; James E.J. Bottomley; Jing Huang
>Subject: [PATCH] SCSI, Brocade FC HBA: Remember to always release_firmware()
>so we don't leak memory.
>
>Once we've called request_firmware() we must remember to call
>release_firmware() to free memory. We don't currently do this in
>bfad_read_firmware(); causing a memory leak.
>
>Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>---
> bfad.c |   11 +++++------
> 1 file changed, 5 insertions(+), 6 deletions(-)
>
>  Compile tested only.
>
>diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
>index 44524cf..d7bafeb 100644
>--- a/drivers/scsi/bfa/bfad.c
>+++ b/drivers/scsi/bfa/bfad.c
>@@ -1558,23 +1558,22 @@ bfad_read_firmware(struct pci_dev *pdev, u32
>**bfi_image,
>
> 	if (request_firmware(&fw, fw_name, &pdev->dev)) {
> 		printk(KERN_ALERT "Can't locate firmware %s\n", fw_name);
>-		goto error;
>+		*bfi_image = NULL;
>+		goto out;
> 	}
>
> 	*bfi_image = vmalloc(fw->size);
> 	if (NULL == *bfi_image) {
> 		printk(KERN_ALERT "Fail to allocate buffer for fw image "
> 			"size=%x!\n", (u32) fw->size);
>-		goto error;
>+		goto out;
> 	}
>
> 	memcpy(*bfi_image, fw->data, fw->size);
> 	*bfi_image_size = fw->size/sizeof(u32);
>-
>+out:
>+	release_firmware(fw);
> 	return *bfi_image;
>-
>-error:
>-	return NULL;
> }
>
> u32 *
>
>
>--
>Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
>Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
>Plain text mails only, please.
