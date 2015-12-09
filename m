From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/3] ses: fix discovery of SATA devices in SAS enclosures
Date: Wed, 09 Dec 2015 12:52:50 -0800
Message-ID: <1449694370.2226.43.camel@HansenPartnership.com>
References: <201512100407.NtBT5c6i%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55894 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973AbbLIUww (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 15:52:52 -0500
In-Reply-To: <201512100407.NtBT5c6i%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org

On Thu, 2015-12-10 at 04:38 +0800, kbuild test robot wrote:
> Hi James,
> 
> [auto build test ERROR on v4.4-rc4]
> [cannot apply to scsi/for-next next-20151209]
> 
> url:    https://github.com/0day-ci/linux/commits/James-Bottomley/Fix-the-problem-of-SATA-devices-within-SAS-enclosures/20151210-031802
> config: i386-randconfig-b0-12100330 (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/built-in.o: In function `ses_match_to_enclosure':
> >> ses.c:(.text+0x1c04ad): undefined reference to `is_sas_attached'
> >> ses.c:(.text+0x1c0519): undefined reference to `sas_get_address'

Oh, that's the perennial file built in but dependencies are modules
problem.  The fix is to add this line to the Kconfig for SCSI_ENCLOSURE

depends on m || SCSI_SAS_ATTRS != m

I'll post a v2 with that added.

James


