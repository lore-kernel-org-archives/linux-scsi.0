From: Clay Haapala <chaapala@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Tue, 02 Dec 2003 17:41:46 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yqujbrqqvlc5.fsf@chaapala-lnx2.cisco.com>
References: <03120118001300.08627@naveenb-lnx.cisco.com>
	<Pine.LNX.4.58.0312011655240.26106@serv>
	<03120217260300.01630@naveenb-lnx.cisco.com>
	<1070383028.2345.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:28547 "EHLO
	sj-iport-4.cisco.com") by vger.kernel.org with ESMTP
	id S264446AbTLBXmG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2003 18:42:06 -0500
In-Reply-To: <1070383028.2345.8.camel@mulgrave> (James Bottomley's message
 of "02 Dec 2003 10:37:01 -0600")
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 02 Dec 2003, James Bottomley said:
> On Tue, 2003-12-02 at 05:56, Naveen Burmi wrote:
>> Our assumption so far was that if a buffer is given to SCSI HBA
>> driver, then nobody can touch the buffer until the HBA says that he
>> is done with the buffer. It seems that this assumption isn't
>> true. Can you give an instance where somebody (probably buffer
>> cache) will modify the buffer which is handed over to an HBA
>> driver?
> 
> This is an incorrect assumption.  The Linux SCSI subsystem is
> architected for zero copy, meaning that if the user maps a copy of
> the data, they can alter it at will, even if it is in flight within
> the driver.  The only thing you can guarantee is that you will get
> another write request for any page the user dirtied.
> 
> Also note that glibc uses mmaping to handle file descriptors in
> linux, so almost every application can alter in-flight data
> depending on how it works.
> 
> James

I'm trying to drive to what a proper design should be, and I am sure
that I'll be a lot smarter when this discussion is done than I am now.
I also kind of feel that we are in Stage 3 Problem-Solving* now.

There are two reasons that the digest could fail:

 1) the network actually silently corrupted the data, which is why
    iSCSI *has* a digest in its RFC, or

 2) (assuming zero-copy) the page(s) in question were modified by the
    user while the digest was being calculated, which is possible,
    indeed probable, as James points out above.

A digest error should return a 0B/4705 COMMAND ABORT and an
initiator is supposed to be free to retry that operation.

Can the iSCSI initiator retry using the identical page it sent before?
No, not if we are in case #2.  Does it matter?  Also No.  The user has
already made the data previously attempted "stale", and it doesn't
matter if it made it to the device or not since the user processes, be
they the filesystem, mmap, or paging, want that data replaced with
whatever is current.

So, given a digest failure, the iSCSI initiator can recalculate the
digest using the current data and retry the operation.  (Yes, and the
page may *still* be being modified, so we go to the top of the loop.)
What would be missing here from a data perspective?

>From a big-picture perspective, would such re-trying impact system
performance?  I would tend to think not, since we are dealing with the
network stack here, and would that not naturally allow other things to
run?  Of course, if little else can run, then the user process
modifying the page won't be able to, and the retries will stop.
Forgive me if I am wrong about that.

Would it be a possible, and perhaps desired, optimization if the
initiator simply returned a "completion OK" in the face of a digest
error IFF it detects that the "guaranteed write request" that James
mentions above is pending for the pages in question?  As in, "Digest
failure on stale data: No Big Deal."  Can it detect the "new" pending
request for those pages?

Digressing, I can see the value of digests for apps like DBMS who are
doing checkpoints and commits and definitely do not pee on their data
after requesting a write of it.  For paging, mmap, etc.?  Naw.
-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
   Active dissent has been part of American government since the
         Boston Tea Party, and will be until its end.

*Stages of Problem-Solving:

1) What problem?
2) Oh, I guess there may be a problem.
3) How the hell did it ever work??
4) Fix the problem.
