From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Comments Needed] scan vs remove_target deadlock
Date: Fri, 14 Apr 2006 12:48:10 -0500
Message-ID: <443FE05A.8090501@cs.wisc.edu>
References: <1144693508.3820.33.camel@localhost.localdomain> <443B2A79.4020600@cs.wisc.edu> <443E6ADC.8080206@emulex.com> <443F23D7.9090000@cs.wisc.edu> <443F772A.3080302@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42459 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751333AbWDNRsT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 13:48:19 -0400
In-Reply-To: <443F772A.3080302@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> 
>> Actually, maybe, I should not have brought this up as it could just be
>> more of a workaround of the core problem. For FC in fc_user_scan() do
>> you need some sort of lock around the rport loop?
> 
> Yes, I had noticed this as well. However, I don't think this is influencing
> the deadlock.
> 

iscsi needed a lock too. And so we ended up just adding a semaphore
around the addition and deletion and scanning of sessions. We also do
some weird things in that we initiate some tasks from userspace
(scanning and shutting down devices, transport shutdown, etc), but the
locking issues are similar and by doing some of the things in userspace
iscsi is just trying to work around some of the issues. I was just
thinking maybe your original thought about a more invasive locking
change may be needed instead of the workaround I was suggesting earlier
in the thread.
