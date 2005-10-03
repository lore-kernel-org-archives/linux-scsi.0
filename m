From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Mon, 03 Oct 2005 16:15:26 -0400
Message-ID: <4341915E.1090705@pobox.com>
References: <Pine.LNX.4.10.10509300015100.27623-100000@master.linux-ide.org> <433D8542.1010601@adaptec.com> <433DD0F8.4000501@pobox.com> <43413CE8.1090306@adaptec.com> <434154F0.9070105@pobox.com> <43415AFC.5080501@adaptec.com> <434160ED.7050803@pobox.com> <43418076.4020706@adaptec.com> <4341874A.7000703@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932684AbVJCUPp@vger.kernel.org>
In-Reply-To: <4341874A.7000703@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Andre Hedrick <andre@linux-ide.org>, "David S. Miller" <davem@davemloft.net>, willy@w.ods.org, patmans@us.ibm.com, ltuikov@yahoo.com, linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

Mike Christie wrote:
> For FC there is code like the fc_rport stuff which exports a sysfs 
> interface but also does a lot more like probing and queue blocking.

> And the iSCSI class does do a lot more now too. This just has not been 
> updated. It handles the userspace to kernel communication, session and 
> connection sysfs interface setup,

Great.  Exactly.


> Structures like the fc_rport and iscsi_session are managed by the 
> transport classes so scsi-ml never knows about them (except for that 
> scanning bug). And it is possible to share them between HW and software 
> or partial software solutions. I do agree for some iscsi sitautions 
> having a layer over the eh or command exection where the transport 
> really is more of a layer like your design would be nice (I am not 
> refferring to the code duplication though becuase iSCSI would like some 
> of yrou fixes :), but at the same time there are places where code can 
> be shared between a interface that hides the lower level details and one 
> that implements them in software. Maybe it is not this way for SAS though.

Adaptec's SAS stuff implements the standard high level SCSI model as an 
API, which is a pretty decent direction for SCSI long term:  provides a 
transport-independent execute-scsi-command high level hook (along with 
the other task management functions), and hides the transport details 
for the most part.

That's fine, and works for iSCSI as well.

I just disagree that we need to have two concurrent APIs for SCSI, 
completely separate from each other, and mildly duplicating each other's 
code.

The current SCSI code will morph in the proper direction given time and 
love.  Segregating generic [SPI | FC | SAS | iSCSI | ATA | RAID | ...] 
transport layer code into their own modules -- the transport classes and 
associated libs -- will point out the sore spots where scsi-ml needs 
changes.  This approach also implies we improve the existing scsi-ml 
where needed, rather than the proposed "if legacy, let it bitrot" approach.

	Jeff
