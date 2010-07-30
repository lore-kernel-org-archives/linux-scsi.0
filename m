From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [PATCH 0/6] scsi_dh : Couple of fixes for scsi device handlers
Date: Thu, 29 Jul 2010 17:04:36 -0700
Message-ID: <1280448276.17620.80.camel@chandra-lucid.beaverton.ibm.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4D05DC420@cosmail01.lsi.com>
	 <1280440444.17620.72.camel@chandra-lucid.beaverton.ibm.com>
	 <E463DF2B2E584B4A82673F53D62C2EF4D0663845@cosmail01.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:36028 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab0G3AD3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2010 20:03:29 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o6TNsr7U008326
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2010 17:54:53 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o6U03EfT074458
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2010 18:03:15 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o6U03E5N023167
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2010 18:03:14 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4D0663845@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Shyam_Iyer@Dell.com" <Shyam_Iyer@Dell.com>, "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>

See comment below

On Thu, 2010-07-29 at 16:35 -0600, Moger, Babu wrote:
> Chandra, Shyam,  
>  Thanks for your comments.. Please see my response.
> 
> > -----Original Message-----
> > From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> > Sent: Thursday, July 29, 2010 4:54 PM
> > To: Moger, Babu
> > Cc: device-mapper development; linux-scsi@vger.kernel.org; Qi, Yanling;
> > Chauhan, Vijay; Dachepalli, Sudhir; Stankey, Robert
> > Subject: Re: [PATCH 0/6] scsi_dh : Couple of fixes for scsi device
> > handlers
> > 
> > Babu,
> > 
> > Your main object is to protect scsi_dh_data across scsi_dh_activate()
> > by
> > way of getting kref around scsi_dh_activate(), right ?
> > 
> 
>   Yes, That is correct. 
> 
> > Wouldn't doing what Shyam suggested (doing kref_put() and put_device())
> > in scsi_activate() make it simpler and code still be readable ? (it
> > would make all the patches except 2/6 not needed).
> > 
> > Did you hit with any problems doing it that way ?
> >
> 
>   Yes, We can do that.  Problem is I am hitting the issue with BUG_ON
>  in get_rdac_data which is there in the beginning of rdac_activate.

I do not understand the problem.

If the BUG_ON on get_rdac_data() is being triggered, that means
sdev->scsi_dh_data is NULL, if that is the case, how can you access
sdev->scsi_dh_data->kref in scsi_dh_activate (in patch 2/6) ? Wouldn't
it trip a oops ?


>   If I have to go this way, then I need to remove a call get_rdac_data
>  and just validate pointers. Report error(SCSI_DH_IO) if pointer is not valid.
>   Then hold the reference counts and continue if everything is alright.
>   I will send the new patches as soon as I can.  


