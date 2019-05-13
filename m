From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: RE: [EXT] [PATCH v1 2/3] scsi: ufs: add error handling of auto-hibern8
Date: Mon, 13 May 2019 18:21:23 +0000
Message-ID: <BN7PR08MB568438668FC7C90A1284F53DDB0F0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1557758186-18706-1-git-send-email-stanley.chu@mediatek.com>
 <1557758186-18706-3-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1557758186-18706-3-git-send-email-stanley.chu@mediatek.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Stanley Chu <stanley.chu@mediatek.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>
Cc: "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>, "andy.teng@mediatek.com" <andy.teng@mediatek.com>, "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>, "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>, "evgreen@chromium.org" <evgreen@chromium.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "sayalil@codeaurora.org" <sayalil@codeaurora.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hi, Stanley

>+
>+static inline bool ufshcd_is_auto_hibern8_error(struct ufs_hba *hba,
>+						u32 intr_mask)
>+{
>+	return (ufshcd_is_auto_hibern8_supported(hba) &&
>+		!hba->uic_async_done &&

Here check if uic_async_done is NULL, no big problem so far, but not safe enough.
How about setting a flag in ufshcd_auto_hibern8_enable(),

I concern about how to compatible with auto_hibern8 disabled condition.


//Bean
