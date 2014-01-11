From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 3/6] libata: resume in the background
Date: Fri, 10 Jan 2014 21:25:39 -0500
Message-ID: <52D0ABA3.9030502@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com>	<1387236657-4852-1-git-send-email-psusi@ubuntu.com>	<1387236657-4852-4-git-send-email-psusi@ubuntu.com> <CAA9_cmfzgNkep_ZBKwyvW3iUXnKyNjpbB1uGtDLonbD1wCM10g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmfzgNkep_ZBKwyvW3iUXnKyNjpbB1uGtDLonbD1wCM10g@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: todd.e.brandt@linux.intel.com, Tejun Heo <tj@kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/10/2014 05:26 PM, Dan Williams wrote:
> I was going to comment that this leaves us open to a race to
> submit new i/o before recovery starts, but scsi_schedule_eh already
> blocks new i/o, so I think we're good.  I think it deserves a
> comment here about why it's safe to not care.

I don't follow, could you explain?

>> 
>> static int ata_port_resume(struct device *dev) { int rc;
>> 
>> +       if (pm_runtime_suspended(dev)) +               return 0;
> 
> Why?  If we dpm_resume() a port that was rpm_suspend()ed the state 
> needs to be reset to active.  I think this check also forces the
> port to resume twice, once for system resume and again for the
> eventual runtime_resume.

It stops the first resume by returning early, so only the second one
happens.

> ...so, the pm_runtime_suspended() check should go and something
> like this folded in:
> 
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c 
> index 92d7797223be..a6cc107c9434 100644 ---
> a/drivers/ata/libata-eh.c +++ b/drivers/ata/libata-eh.c @@ -4143,5
> +4143,11 @@ static void ata_eh_handle_port_resume(struct ata_port
> *ap) ap->pm_result = NULL; } spin_unlock_irqrestore(ap->lock,
> flags); + +       if (rc == 0) { +
> pm_runtime_disable(dev); +
> pm_runtime_set_active(dev); +
> pm_runtime_enable(dev); +       } } #endif /* CONFIG_PM */

Ahh, and that will stop the second resume, rather than the previous
change to stop the first?

Don't we want to stop the first rather than the second?  Otherwise if
the port is runtime suspended at system suspend time ( maybe no drive
connected to it? ) then there is no sense in resuming it at system
resume time.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJS0KujAAoJEI5FoCIzSKrwhQsH/0f4AywqDM1y1BOPSFNuiF/X
5SRz1BaXCs7AZhSBcBrS5H9lZJLUQoKshUFXHtV9A4DuRhIghl+cu7JsJt3aPlmM
u2yx3xETTj/iLqnL4shHVta/y9gXCfXhO7qZNtcDyPmiSgPNlFM4ZFTnnXtKaVgj
PxZPzLqLA+Oh/iTgOXLsC/CECrLdWm6paTE6ii04QiabUjbK9vKk7EqazRnrlnsC
I3MzulTu8jDLxMtwpdPPYUvi93BQr2P1Q11u/Rt8za+Y19h3UXpb2ATEiuHeYcNK
F/HpXR+zDDSKSDnE591pF5q6gsC1MHt4+Zq0g7ZfpparO+2TciQo0hLs09hVEhI=
=Cu86
-----END PGP SIGNATURE-----
