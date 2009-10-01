From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [PATCH 0/4] scsi_dh: Make scsi_dh_activate asynchronous
Date: Thu, 01 Oct 2009 13:54:03 -0700
Message-ID: <1254430443.24692.4.camel@chandra-ubuntu>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF474E78371@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:41587 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbZJAUxy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 16:53:54 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n91Kptpb009312
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2009 14:51:55 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n91KrmwV124760
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2009 14:53:50 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n91KrjjY001020
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2009 14:53:48 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474E78371@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Benoit_Arthur@emc.com" <Benoit_Arthur@emc.com>, "Eddie.Williams@steeleye.com" <Eddie.Williams@steeleye.com>, "berthiaume_wayne@emc.com" <berthiaume_wayne@emc.com>

Thanks Babu,

I will fix the issues you pointed.

Let me know how the testing goes.

It will be nice if you could also review the code :)

chandra
On Wed, 2009-09-30 at 22:19 -0600, Moger, Babu wrote:
> Hi Chandra,
>    Thanks for the patches. Patches applied cleanly on 2.6.31. I am testing the patches right now. Will post the with test results tomorrow.
> These are my initial comments. 
> 1. Patches do not apply on 2.6.32. You may have to regenerate it on 2.6.32.
> 2. Also, I noticed few errors and warnings while running checkpatch.pl script.  
> 3. Subject line for patch 3 and 4 may need to be modified. It still says "rdac handler". It should be hp and alua handler. 
> 
> Thanks..
> 
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of Chandra Seetharaman
> > Sent: Tuesday, September 29, 2009 9:08 PM
> > To: linux-scsi@vger.kernel.org
> > Cc: dm-devel@redhat.com; Moger, Babu; michaelc@cs.wisc.edu;
> > Benoit_Arthur@emc.com; Eddie.Williams@steeleye.com;
> > berthiaume_wayne@emc.com; Chandra Seetharaman
> > Subject: [PATCH 0/4] scsi_dh: Make scsi_dh_activate asynchronous
> > 
> > Hello All,
> > 
> > Currently, device handlers process path activation in series. This leads
> > to a lot of time delay when more than 100 luns are involved. For example,
> > with lsi rdac 100+ luns take about 12-15 minutes. This was found by Moger
> > Babu of LSI.
> > 
> > This time delay can be avoided if we can do the activations
> > asynchronously.
> > By making scsi_dh_activate() async, we can give the device handlers an
> > oppurtunity to decide on how to send the device activation down the wire
> > to make the turn around time faster. They can send the commands
> > asynchronously or send them in batches.
> > 
> > I brought up this issue on the mailing list
> > (http://marc.info/?l=linux-scsi&m=123888063818755&w=2) and provided a
> > set of patch a loooong while back http://marc.info/?l=linux-
> > scsi&m=124088712709821&w=2
> > 
> > This set of patches applies cleanly on 2.6.31 and I tested the rdac
> > handler
> > on the same.
> > 
> > Please review and provide comments.
> > 
> > This set of patched adds asynchronous support for rdac, hp, and alua
> > handlers.
> > 
> > Didn't add async support for EMC for the following reasons:
> >  - EMC handler is getting more hairy (when I try to move to _nowait())
> >  - I do not know if EMC has a special command to group them (like rdac).
> >  - I wasn't sure if EMC has this problem in the first place ( I did not
> > get
> >    any response from EMC).
> > Can somebody from EMC comment, please.
> > 
> > Thanks & Regards,
> > 
> > chandra
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

