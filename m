From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Comments Needed] scan vs remove_target deadlock
Date: Thu, 13 Apr 2006 23:23:51 -0500
Message-ID: <443F23D7.9090000@cs.wisc.edu>
References: <1144693508.3820.33.camel@localhost.localdomain> <443B2A79.4020600@cs.wisc.edu> <443E6ADC.8080206@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55000 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751110AbWDNEX7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 00:23:59 -0400
In-Reply-To: <443E6ADC.8080206@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
>> Do we
>> need the scan mutex to change the device state? I mean if a scan has
>> the mutex lock, and the transport class decides to remove the device
>> it tries to grab the scan_mutex by calling scsi_remove_device, but if
>> we moved the state change invocation before the scan_mutex is taken in
>> scsi_remove_device then, I assume eventually the device should get
>> unplugged, the prep or request_fn will see the new state and fail the
>> request.
> 
> This may be what's needed. I don't understand all of this path yet, so I
> can only speculate (and likely w/ error). Thus, the questions.

Actually, maybe, I should not have brought this up as it could just be
more of a workaround of the core problem. For FC in fc_user_scan() do
you need some sort of lock around the rport loop?
