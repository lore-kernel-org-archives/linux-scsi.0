From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 6/7] scsi_dh: Update RDAC device handler
Date: Fri, 16 May 2008 11:40:23 -0700
Message-ID: <1210963223.21974.338.camel@chandra-ubuntu>
References: <20080514144334.09AA610B5DF@craiglockhart-ipmi.suse.de>
	 <1210819830.21974.268.camel@chandra-ubuntu>  <482BFC21.8070600@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59420 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbYEPSig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2008 14:38:36 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4GIcafi018274
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 14:38:36 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4GIcaia077592
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 14:38:36 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4GIcZVS016027
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 14:38:35 -0400
In-Reply-To: <482BFC21.8070600@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, dm-devel <dm-devel@redhat.com>


On Thu, 2008-05-15 at 11:02 +0200, Hannes Reinecke wrote:
<snip>

> >> @@ -478,24 +491,9 @@ static int rdac_activate(struct scsi_device *sdev)
> >>  	struct rdac_dh_data *h = get_rdac_data(sdev);
> >>  	int err = SCSI_DH_OK;
> >>
> >> -	if (h->lun == UNINITIALIZED_LUN) {
> >> -		err = get_lun(sdev);
> >> -		if (err != SCSI_DH_OK)
> >> -			goto done;
> >> -	}
> >> -
> >>  	err = check_ownership(sdev);
> >> -	switch (err) {
> >> -	case RDAC_UNOWNED:
> >> -		break;
> >> -	case RDAC_OWNED:
> >> -		err = SCSI_DH_OK;
> >> -		goto done;
> >> -	case RDAC_FAILED:
> >> -	default:
> >> -		err = SCSI_DH_IO;
> > 
> > What does this change yield ? (under check_ownership)
> > 
> We're now setting the lun state explicitly, so there's
> no need to return different error codes.

That is my question. what did we gain by the addition of lun_state ?


