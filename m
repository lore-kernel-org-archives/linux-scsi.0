From: Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: [RFC PATCH 35/35] Add Xen virtual block device driver.
Date: Mon, 27 Mar 2006 21:14:23 +1100
Message-ID: <17447.47871.35204.347588@wombat.chubb.wattle.id.au>
References: <A95E2296287EAD4EB592B5DEEFCE0E9D4B9E8A@liverpoolst.ad.cl.cam.ac.uk>
	<4421D943.1090804@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail05.syd.optusnet.com.au ([211.29.132.186]:54498 "EHLO
	mail05.syd.optusnet.com.au") by vger.kernel.org with ESMTP
	id S1750864AbWC0KTN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 05:19:13 -0500
In-Reply-To: <4421D943.1090804@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Ian Pratt <m+Ian.Pratt@cl.cam.ac.uk>, Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, Ian Pratt <ian.pratt@xensource.com>, ian.pratt@cl.cam.ac.uk, SCSI Mailing List <linux-scsi@vger.kernel.org>

>>>>> "Jeff" == Jeff Garzik <jeff@garzik.org> writes:

Jeff> Ian Pratt wrote:
>> 
>> We certainly should be pushing everyone toward using the 'xdX' etc
>> devices that are allocated to us. However, the installers of
>> certain older distros and other user space tools won't except
>> anything other than hdX/sdX, so its useful from a compatibility POV
>> even if it never goes into mainline, which I agree it probably
>> shouldn't.

Jeff> Yes, this is true.  Red Hat installer guys grumbled at me when I
Jeff> wrote the 'sx8' block driver: since it wasn't hda/sda, they had
Jeff> to write special code for it, as they apparently must do for any
Jeff> new block driver "class".  SuSE and other distros are probably
Jeff> similar, since each block driver provides its own special
Jeff> behaviors and feature exports.

Jeff> I should have spoken up a long time ago about this, but anyway:

Jeff> An IBM hypervisor on ppc64 communicates uses SCSI RPC messages.
Jeff> I think this would be quite nice for Xen, because SCSI (a) is a
Jeff> message-based model, and (b) implementing block using SCSI has a
Jeff> very high Just Works(tm) value which cannot be ignored.  And
Jeff> perhaps (c) SCSI target code already exists, so implementing the
Jeff> server side doesn't require starting from scratch, but rather
Jeff> simply connecting the Legos.

The IA64 virtualisation work (Xen and Linux-on-Linux) uses the SKI
simulator virtual scsi device --- which looks just like any other scsi
disk, but uses hypervisor calls to do read/write/open/close calls like
a user-mode process.  For performance, it needs to be extended a bit
to do asynchronous I/O and interrupt on completion.  As a halfway
house, the ski simscsi driver would be fairly easy to port, I think.

-- 
Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
http://www.ertos.nicta.com.au           ERTOS within National ICT Australia
