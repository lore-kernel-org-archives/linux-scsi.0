From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 00/11] target_core_mod: ALUA updates
Date: Tue, 12 Nov 2013 13:49:45 -0800
Message-ID: <1384292985.12281.103.camel@haakon3.risingtidesystems.com>
References: <1381908048-82014-1-git-send-email-hare@suse.de>
	 <1383771282.4216.67.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56766 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab3KLVtq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2013 16:49:46 -0500
In-Reply-To: <1383771282.4216.67.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2013-11-06 at 12:54 -0800, Nicholas A. Bellinger wrote:
> Hello Hannes,
> 
> Any updates on this series..?
> 
> I'd really like to get the -v2 of this included for v3.13, along with
> the initial Referrals bits.
> 

Any update Hannes..?

I'm fine with merging this series without the common ALUA definition
breakout with scsi_dh_alua for v3.13..

Care to respin a -v2 with the handful of minor comments in the original
posting..?

--nab

> 
> On Wed, 2013-10-16 at 09:20 +0200, Hannes Reinecke wrote:
> > Hi Nic,
> > 
> > here are some updates to TCM ALUA handling. Apart from some
> > minor fixes and spellchecks the main features are:
> > - Make supported states configurable:
> >   We should make the list of supported ALUA states configurable,
> >   as some setups would possibly like to support a small subset
> >   of ALUA states only.
> > - Asynchronous transitioning: I've switched 'transitioning'
> >   handling to use a workqueue, that should allow us to simulate
> >   asynchronous transitioning modes. IE TCM should now be capable
> >   of handling requests while in transitioning, and properly terminate
> >   these with the correct sense code.
> > - Include target device descriptor in VPD page 83
> >   For the ALUA device handler we'd need to identify the target device
> >   where a given target port belongs to. So include the respective
> >   values in the VPD page.
> > 
> > Hannes Reinecke (11):
> >   target core: rename (ex,im)plict -> (ex,im)plicit
> >   target_core_alua: Store supported ALUA states
> >   target_core_alua: Make supported states configurable
> >   target_core_alua: Rename ALUA_ACCESS_STATE_OPTIMIZED
> >   target_core_alua: spellcheck
> >   target_core_alua: Validate ALUA state transition
> >   target_core_alua: Allocate ALUA metadata on demand
> >   target_core_alua: store old and pending ALUA state
> >   target_core_alua: Use workqueue for ALUA transitioning
> >   target_core: simplify scsi_name_len calculation
> >   target_core_spc: Include target device descriptor in VPD page 83
> > 
> >  drivers/target/target_core_alua.c      | 456 ++++++++++++++++++++-------------
> >  drivers/target/target_core_alua.h      |  36 ++-
> >  drivers/target/target_core_configfs.c  |  76 +++++-
> >  drivers/target/target_core_device.c    |   6 +-
> >  drivers/target/target_core_file.c      |   2 +-
> >  drivers/target/target_core_pr.c        |  24 +-
> >  drivers/target/target_core_spc.c       |  62 ++++-
> >  drivers/target/target_core_transport.c |   4 +-
> >  drivers/target/target_core_ua.h        |   2 +-
> >  include/target/target_core_base.h      |  14 +-
> >  10 files changed, 442 insertions(+), 240 deletions(-)
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


