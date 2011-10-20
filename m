From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Simulating faulty disk
Date: Thu, 20 Oct 2011 16:56:25 +0100
Message-ID: <4EA044A9.6070406@redhat.com>
References: <4E9F9321.8090704@cs.utah.edu> <4E9FE97E.4030209@redhat.com> <4EA04201.1050702@cs.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab1JTP4e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2011 11:56:34 -0400
In-Reply-To: <4EA04201.1050702@cs.utah.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yathindra <ydev@cs.utah.edu>
Cc: linux-scsi@vger.kernel.org

On 10/20/2011 04:45 PM, Yathindra wrote:
> Hi Bryn,
>
> Thanks for that info. Could you please tell me where I can find more
> details about using it.
>
> Thanks again,
> Yathi

There's a couple of brief files describing the targets in the 
Documentation/device-mapper directory:

http://www.kernel.org/doc/Documentation/device-mapper/dm-flakey.txt
http://www.kernel.org/doc/Documentation/device-mapper/delay.txt

They both work like the linear target (except that they introduce the 
specified faults according to their parameters).

To set up a device with both you'd need to use a pair of stacked devices 
so something like:

dmsetup create d0 --table="0 $SECTORS delay $DEVICE 0 500"
dmsetup create f0 --table="0 $SECTORS flakey /dev/mapper/d0 0 9 1"

This will create a device /dev/mapper/f0 that is drops out for 1s in 
every 10 and has a 500ms delay on reads and writes. SECTORS is the size 
of the underlying device in sectors (use e.g. $(blockdev --getsize)).

You can optionally specify separate delays/device for writes to the 
delay layer and write loss / write corruption for the flakey layer - see 
the doc files and also the comments above flakey_ctr and delay_ctr for 
more details.

Regards,
Bryn.
