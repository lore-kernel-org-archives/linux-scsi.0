From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 03/17] be2iscsi: Fix to use atomic bit operations for
 tag_state
Date: Wed, 20 Jan 2016 11:13:50 +0100
Message-ID: <569F5DDE.80900@suse.de>
References: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1453279261-659-4-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934903AbcATKNv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 05:13:51 -0500
In-Reply-To: <1453279261-659-4-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 01/20/2016 09:40 AM, Jitendra Bhivare wrote:
> beiscsi_mccq_compl sets MCC_TAG_STATE_TIMEOUT before setting up
> tag_mem_state. be_mcc_compl_process_isr checks for
> MCC_TAG_STATE_TIMEOUT first then accesses tag_mem_state which might b=
e
> still getting populated in the process context.
>=20
> Fix:
> Set MCC_TAG_STATE_TIMEOUT after tag_mem_state is populated.
> Removed MCC_TAG_STATE_COMPLETED. When posted its in running state and
> the running state is cleared in be_mcc_compl_process_isr.
> be_mcc_notify now takes tag argument to set it to running state.
> Use bit operations for tag_state. Use barriers before setting the sta=
te.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be.h      |   7 ++-
>  drivers/scsi/be2iscsi/be_cmds.c | 111 ++++++++++++++++++++----------=
----------
>  drivers/scsi/be2iscsi/be_cmds.h |   4 +-
>  drivers/scsi/be2iscsi/be_mgmt.c |  39 ++++++++------
>  4 files changed, 84 insertions(+), 77 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
