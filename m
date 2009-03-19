From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] Evaluate TPGS setting for ALUA device handler
Date: Thu, 19 Mar 2009 03:41:08 -0700
Message-ID: <1237459268.4138.57.camel@haakon2.linux-iscsi.org>
References: <49C1FCE0.3040808@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:24797 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751810AbZCSKlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Mar 2009 06:41:11 -0400
In-Reply-To: <49C1FCE0.3040808@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2009-03-19 at 09:05 +0100, Hannes Reinecke wrote:
> The ALUA device handler should only be attached if the 'TPGS' setting
> in the inquiry structure indicates so. So we should be evaluating the
> 'tpgs' setting when trying to attach the ALUA device handler.
> This way we can get rid of the explicit device table in scsi_dh_alua
> and will support any ALUA capable device out-of-the-box.
> 
> This is a repost of the patchset send yesterday, including
> the suggestions from James B. to just pull the tpgs setting
> off the inquiry data instead of adding a new field in the
> scsi_device structure.

Hannes and co, these patches looks fine to me..   The plan on my side to
is start testing the scsi_dh_alua client changes againt the
lio-core-2.6.git implict ALUA logical unit group and target port group
bits for v2.6.30.  Getting the initial optimized <-> non optimize ALUA
state transitions up should be done in the next weeks for you to poke at
seriously against your scsi_dh_alua nodes using Open/iSCSI.  Also from
there the first explict ALUA using MO_SET_TARGET_PGS.

>From there target_core_mod PR and ALUA fabric against OpenFCoE target
ports and all sorts of Linux Cluster clients is not too far away.

:-)

--nab

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

