From: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
Subject: Re: [PATCH v3 1/5] [SCSI] ufshcd: UFS Host controller driver
Date: Mon, 26 Mar 2012 13:32:57 +0900
Message-ID: <4F6FF179.5090600@toshiba.co.jp>
References: <1330497714-26504-2-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1330497714-26504-2-git-send-email-santoshsy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org, saugata.das@linaro.org, dsaxena@linaro.org, stephen.doel@linaro.org, venkat@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, sreekumar.c@samsung.com, vinholikatti@gmail.com, linkinjeon@gmail.com, michaelc@cs.wisc.edu
List-Id: linux-scsi@vger.kernel.org

> > +        utrdlp[i].response_upiu_length =
> > +                cpu_to_le16(ALIGNED_UPIU_SIZE);

Response UPIU Length(RUL) shows the response UPIU length in Dword.
(JEDEC Standard No.223 6.2.1 UTP Transfer Request Descriptor)
The following will be correct.

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 07ec973..feffe65 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -836,7 +836,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
                 utrdlp[i].prd_table_offset =
                                 cpu_to_le16((prdt_offset >> 2));
                 utrdlp[i].response_upiu_length =
-                               cpu_to_le16(ALIGNED_UPIU_SIZE);
+                               cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);

                 hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
                 hba->lrb[i].ucd_cmd_ptr =
