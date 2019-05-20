From: Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH v2 0/3] scsi: ufs: Add error handling of Auto-Hibernate
Date: Mon, 20 May 2019 09:15:37 +0800
Message-ID: <1558314937.660.2.camel@mtkswgap22>
References: <1557912988-26758-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1557912988-26758-1-git-send-email-stanley.chu@mediatek.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>, Andy Teng =?UTF-8?Q?=28=E9=84=A7=E5=A6=82=E5=AE=8F=29?= <Andy.Teng@mediatek.com>, Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=E9=A7=BF=E5=AE=8F=29?= <Chun-hung.Wu@mediatek.com>, Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=E5=9C=8B=E9=B4=BB=29?= <kuohong.wang@mediatek.com>, "evgreen@chromium.org" <evgreen@chromium.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>, "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, Peter Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?= <peter.wang@mediatek.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org

Hi Avri, Alim, Pedro,

Gentle ping for this patch.

On Wed, 2019-05-15 at 17:36 +0800, Stanley Chu wrote:
> Currently auto-hibernate is activated if host supports
> auto-hibern8 capability. However error-handling is not implemented,
> which makes the feature somewhat risky.
> 
> If either "Hibernate Enter" or "Hibernate Exit" fail during
> auto-hibernate flow, the corresponding interrupt
> "UIC_HIBERNATE_ENTER" or "UIC_HIBERNATE_EXIT" shall be raised
> according to UFS specification.
> 
> This patch adds auto-hibernate error-handling:
> 
> - Monitor "Hibernate Enter" and "Hibernate Exit" interrupts after
>   auto-hibernate feature is activated.
> 
> - If fail happens, trigger error-handling just like "manual-hibernate"
>   fail and apply the same recovery flow: schedule UFS error handler in
>   ufshcd_check_errors(), and then do host reset and restore
>   in UFS error handler.
> 
> v2:
>  - Fix sentences in commit message (Marc Gonzalez)
>  - Make "Auto-Hibernate" error detection more precise (Bean Huo)
> 
> Stanley Chu (3):
>   scsi: ufs: Do not overwrite Auto-Hibernate timer
>   scsi: ufs: Add error-handling of Auto-Hibernate
>   scsi: ufs: Use re-factored Auto-Hibernate function
> 
>  drivers/scsi/ufs/ufshcd.c | 33 ++++++++++++++++++++++++++++++++-
>  drivers/scsi/ufs/ufshcd.h |  5 +++++
>  drivers/scsi/ufs/ufshci.h |  3 +++
>  3 files changed, 40 insertions(+), 1 deletion(-)
> 
Thanks,
Stanley
