From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] dm mpath: Try recover from I/O failure by
	re-initializing the PG if device is running on one path
Date: Wed, 22 Apr 2009 11:43:39 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF466A671C0@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF466A0E4DA@cosmail01.lsi.com>
	 <49ED1C24.9090303@ct.jp.nec.com>
	 <E463DF2B2E584B4A82673F53D62C2EF466A66DD4@cosmail01.lsi.com>
	 <49EE7870.3090008@ct.jp.nec.com>
	 <E463DF2B2E584B4A82673F53D62C2EF466A6707A@cosmail01.lsi.com>
 <1240421599.19442.8.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:53209 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZDVRnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 13:43:49 -0400
In-Reply-To: <1240421599.19442.8.camel@chandra-ubuntu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>


> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Wednesday, April 22, 2009 12:33 PM
> To: Moger, Babu
> Cc: Kiyoshi Ueda; 'dm-devel@redhat.com'; linux-scsi@vger.kernel.org;
> Chauhan, Vijay
> Subject: RE: [PATCH] dm mpath: Try recover from I/O failure by re-
> initializing the PG if device is running on one path
> 
> You mean to say that we do not require this patch/fix ?
 

 No. I did not mean that. What I meant was re-activating the path from device handler (rdac_check_sense) is not an option. We have to find other ways to deal with it. 

Lun ownership change can happen if the user knowingly or unknowingly changes the ownership. Also our redistribute feature can change the lun ownership.


> On Wed, 2009-04-22 at 08:03 -0600, Moger, Babu wrote:
> > Hi Kiyoshi,
> >
> > > >>
> > > >> Hi Babu,
> > > >>
> > > >> On 2009/04/21 3:05 +0900, Moger, Babu wrote:
> > > >>> This patch introduces the mechanism to recover from I/O failures
> by
> > > >>> re-initializing the path if the device is running on only one
> path.
> > > >>>
> > > >>> Problem: Device mapper fails the path for every I/O error. It does
> not
> > > >>> care about the type of error. There are certain errors which can
> be
> > > >>> recovered by re-initializing the path again. I have seen this
> problem
> > > >>> during my testing on rdac device handler. I have observed I/O
> errors
> > > >>> when there is a change in Lun ownership. When Lun ownership
> changes
> > > >>> device will return back with check condition with
> > > >>> sense 0x05/0x94/0x01(SK/ASC/ASCQ -meaning Lun ownership changed).
> > > >>> Currently, device mapper fails the path for this error and
> eventually
> > > >>> this will lead to I/O error. We don't want to see I/O error for
> this
> > > >>> reason.
> > > >>
> > > >> Shouldn't we handle this type of device error inside device
> handler?
> > > >
> > > > The current error in question requires re-activation of the path.
> > > > We already have a code to handle this scenario in device handler.
> > > > But, the problem is the return status does not go to DM layer.
> > > > The return status gets lost in scsi layer. For DM layer all the
> errors
> > > > are -EIO. Any thoughts from your side.
> > >
> > > Oh, I missed the point and I thought that re-activating the path
> > > in your device handler was enough for the error.
> > > Currently, I have no idea to handle your case only in dm without
> > > seeing I/O error.
> > >
> >   I have discussed about re-activating path in device handler with
> Chandra. Looks like that will lead to other issues (one is long boot up).
> Look like that is not an option.
> > > By the way, who did change the ownership when the device was running
> > > with one path in your testing?  I can't see why such case happened.
> > >
> > This can happen if the user knowingly or unknowingly changes the
> ownership. Also we have other feature in our storage which will allow user
> to redistribute the luns. Thanks for you comment.
> >
> > > Thanks,
> > > Kiyoshi Ueda
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

