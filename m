From: Avri Altman <Avri.Altman-Sjgp3cTcYWE@public.gmane.org>
Subject: RE: [PATCH v5 0/3] scsi: ufs: Add error handling of Auto-Hibernate
Date: Tue, 21 May 2019 08:41:32 +0000
Message-ID: <SN6PR04MB4925604BFAF0A66D54F65E3EFC070@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1558421094-3182-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1558421094-3182-1-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org" <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, "pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org" <pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: "marc.w.gonzalez-GANU6spQydw@public.gmane.org" <marc.w.gonzalez-GANU6spQydw@public.gmane.org>, "andy.teng-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <andy.teng-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "evgreen-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <evgreen-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "beanhuo-AL4WhLSQfzjQT0dZR+AlfA@public.gmane.org" <beanhuo-AL4WhLSQfzjQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This series looks fine to me.

Thanks,
Avri

> 
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
> v5:
>  - Also re-factor checking of Auto-Hibernation support in other places, e.g., in
> ufshcd_auto_hibern8_enable() and in ufs-sysfs (Avri Altman)
>  - Change order of patch "scsi: ufs: Introduce
> ufshcd_is_auto_hibern8_supported()" to #1 as a preparation patch of whole
> series
> 
> v4:
>  - Replace original patch "[3/3] scsi: ufs: Use re-factored Auto-Hibernate
> function" by a new preparation patch "[2/3] scsi: ufs: Introduce
> ufshcd_is_auto_hibern8_supported()" for re-factoring
> ufshcd_is_auto_hibern8_supported (Avri Altman)
>  - Refine UIC mask definitions (Avri Altman)
> 
> v3:
>  - Fix typo in patch "scsi: ufs: Do not overwrite Auto-Hibernate timer" (Avri
> Altman)
>  - Rebase to Linux 5.2-rc1
> 
> v2:
>  - Fix sentences in commit message (Marc Gonzalez)
>  - Make "Auto-Hibernate" error detection more precise (Bean Huo)
> 
> Stanley Chu (3):
>   scsi: ufs: Introduce ufshcd_is_auto_hibern8_supported()
>   scsi: ufs: Do not overwrite Auto-Hibernate timer
>   scsi: ufs: Add error-handling of Auto-Hibernate
> 
>  drivers/scsi/ufs/ufs-sysfs.c |  6 +++---
>  drivers/scsi/ufs/ufshcd.c    | 35 +++++++++++++++++++++++++++++++++--
>  drivers/scsi/ufs/ufshcd.h    |  5 +++++
>  drivers/scsi/ufs/ufshci.h    |  6 ++++--
>  4 files changed, 45 insertions(+), 7 deletions(-)
> 
> --
> 2.18.0
