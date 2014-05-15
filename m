From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] target: Don't allow setting WC emulation if device
 doesn't support
Date: Wed, 14 May 2014 17:57:10 -0700
Message-ID: <1400115430.7127.82.camel@haakon3.risingtidesystems.com>
References: <1400107687-15797-1-git-send-email-agrover@redhat.com>
	 <1400112426.7127.60.camel@haakon3.risingtidesystems.com>
	 <537408CC.2070704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46210 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaEOA5M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 May 2014 20:57:12 -0400
In-Reply-To: <537408CC.2070704@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2014-05-14 at 17:22 -0700, Andy Grover wrote:
> On 05/14/2014 05:07 PM, Nicholas A. Bellinger wrote:
> > On Wed, 2014-05-14 at 15:48 -0700, Andy Grover wrote:
> >> Just like for pSCSI, if the transport sets get_write_cache, then it is
> >> not valid to enable write cache emulation for it. Return an error.
> >>
> >> see https://bugzilla.redhat.com/show_bug.cgi?id=1082675
> >>
> >> Reviewed-by: Chris Leech <cleech@redhat.com>
> >> Signed-off-by: Andy Grover <agrover@redhat.com>
> >> ---
> >>   drivers/target/target_core_device.c | 8 ++++----
> >>   1 file changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> >> index 65001e1..d461ecb 100644
> >> --- a/drivers/target/target_core_device.c
> >> +++ b/drivers/target/target_core_device.c
> >> @@ -798,10 +798,10 @@ int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
> >>   		pr_err("emulate_write_cache not supported for pSCSI\n");
> >>   		return -EINVAL;
> >>   	}
> >> -	if (dev->transport->get_write_cache) {
> >> -		pr_warn("emulate_write_cache cannot be changed when underlying"
> >> -			" HW reports WriteCacheEnabled, ignoring request\n");
> >> -		return 0;
> >> +	if (flag &&
> >> +	    dev->transport->get_write_cache) {
> >> +		pr_err("emulate_write_cache not supported for this device\n");
> >> +		return -EINVAL;
> >>   	}
> >>
> >>   	dev->dev_attrib.emulate_write_cache = flag;
> >
> > Allowing the target WCE bit to be disabled when the underlying device
> > has WCE enabled is a recipe for disaster.
> >
> > How is the initiator supposed to know when to flush writes if the target
> > is telling it that WCE is disabled.
> >
> > I'll take change to return -EINVAL here, but the other part is dangerous
> > and wrong.
> 
> This is for backstores like iblock, where we're actually getting WCE 
> yes/no from the backing block device. This configfs entry is not for WCE 
> yes/no, it is for WCE *emulation* yes/no.
> 

Huh..?  The only thing that emulate_write_cache controls is the
reporting of WCE via the caching mode page + EVPD=0x86 for FILEIO + RD
backends.

> So we should allow emulate_write_cache to be set to 0, because we're not 
> emulating the write cache value, we're using the actual value... but we 
> shouldn't allow it to be enabled if we're getting real WCE yes/no values.

There is no point in touching the emulate_write_cache value for IBLOCK.
It's already being ignored in spc_check_dev_wce() anyways.

> So I'm still not seeing how this is not the right thing to do, 
> especially since it's identical to the pscsi case immediately above.

PSCSI is providing it's own control bits, so the assignment in
se_dev_set_emulate_write_cache() is pointless as well.

Just get rid of the unnecessary flag check, and make both PSCSI + IBLOCK
cases return -EINVAL.

--nab

