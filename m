From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Comments Needed] scan vs remove_target deadlock
Date: Fri, 14 Apr 2006 12:58:52 -0500
Message-ID: <443FE2DC.1050009@cs.wisc.edu>
References: <1144693508.3820.33.camel@localhost.localdomain> <443B2A79.4020600@cs.wisc.edu> <443E6ADC.8080206@emulex.com> <443F23D7.9090000@cs.wisc.edu> <443F772A.3080302@emulex.com> <443FE05A.8090501@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46299 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751344AbWDNR7N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 13:59:13 -0400
In-Reply-To: <443FE05A.8090501@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Mike Christie wrote:
> James Smart wrote:
>>> Actually, maybe, I should not have brought this up as it could just be
>>> more of a workaround of the core problem. For FC in fc_user_scan() do
>>> you need some sort of lock around the rport loop?
>> Yes, I had noticed this as well. However, I don't think this is influencing
>> the deadlock.
>>
> 
> iscsi needed a lock too. And so we ended up just adding a semaphore
> around the addition and deletion and scanning of sessions. We also do

Do what can happen is that we go from

iscs_user_scan()
	grab iscsi lock around sessions
		scsi-ml scan()
			grab scsi scan lock


delete session
	grab iscsi lock
	remove session from sessions list

	scsi ml host/decice deletion
		grab scsi scan lock

and I am just saying I think we are duplicating some of the locking in
the transport class (due to some weirdness with the userspace
workarounds this is more or less true).
