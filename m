From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 11/15] lpfc 8.2.8 : Update driver to use new Host byte
	error code DID_TRANSPORT_DISRUPTED
Date: Thu, 04 Sep 2008 16:08:18 -0500
Message-ID: <1220562498.3276.60.camel@localhost.localdomain>
References: <1219629018.7890.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47807 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755515AbYIDVIU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2008 17:08:20 -0400
In-Reply-To: <1219629018.7890.41.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Sun, 2008-08-24 at 21:50 -0400, James Smart wrote:
> Update driver to use new Host byte error code DID_TRANSPORT_DISRUPTED.
> 
> This patch depends pending upstream patches described in:
> http://marc.info/?l=linux-scsi&m=121263014808604&w=2
> 
> Particularly:
> http://marc.info/?l=linux-scsi&m=121263014908607&w=2
> which defines DID_TRANSPORT_DISRUPTED.
> 
> This patch supercedes the lpfc patch in that series:
> http://marc.info/?l=linux-scsi&m=121263015008616&w=2

I've got this one, but only partially.  The third hunk doesn't apply:

--- 1072,1078 ----
  	 * transport is still transitioning.
  	 */
  	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+ 		cmnd->result = ScsiResult(DID_TRANSPORT_DISRUPTED, 0);
  		goto out_fail_command;
  	}

It became a goto out_target_busy, which returns SCSI_MLQUEUE_TARGET_BUSY
via a patch which you acked.

James


