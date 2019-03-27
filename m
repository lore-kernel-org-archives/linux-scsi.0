From: Avri Altman <Avri.Altman-Sjgp3cTcYWE@public.gmane.org>
Subject: RE: [PATCH RESEND v3 2/5] scsi: ufs: Avoid configuring regulator with
 undefined voltage range
Date: Wed, 27 Mar 2019 10:35:47 +0000
Message-ID: <SN6PR04MB49255CFD296BED8C8DEFEFD8FC580@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1553680707-28579-1-git-send-email-stanley.chu@mediatek.com>
 <1553680707-28579-3-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1553680707-28579-3-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
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
Cc: "marc.w.gonzalez-GANU6spQydw@public.gmane.org" <marc.w.gonzalez-GANU6spQydw@public.gmane.org>, "chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

> 
> For regulators used by UFS, vcc, vccq and vccq2 will have voltage range
> initialized by ufshcd_populate_vreg(), however other regulators may
> have undefined voltage range if dt-bindings have no such definition.
> 
> In above undefined case, both "min_uV" and "max_uV" fields in ufs_vreg
> struct will be zero values and these values will be configured on
> regulators in different power modes.
> 
> Currently this may have no harm if both "min_uV" and "max_uV"
> always keep "zero values" because regulator_set_voltage() will always
> bypass such invalid values and return "good" results.
> 
> However improper values shall be fixed to avoid potential bugs.
> Simply bypass voltage configuration if voltage range is not defined.
> 
> Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Reviewed-by: Avri Altman <avri.altman-Sjgp3cTcYWE@public.gmane.org>
