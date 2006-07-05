From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] [PATCH 0/7] requested for qla4xxx!!!
Date: Wed, 05 Jul 2006 12:30:07 -0500
Message-ID: <44ABF71F.4060206@cs.wisc.edu>
References: <20060629064812.GA7220@ranandlinuxbox.oc.cox.net> <44A6CCBC.7000603@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47313 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964927AbWGERa2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2006 13:30:28 -0400
In-Reply-To: <44A6CCBC.7000603@tls.msk.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Ravi Anand <ravi.anand@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, open-iscsi <open-iscsi@googlegroups.com>

Michael Tokarev wrote:
> [Sorry for repost: was typo in linux-scsi@vger
>  email, and open-iscsi@ didn't accept email
>  either, as it says "i'm not subscribed" (which
>  isn't _entirely_ true ;)]
> 
> Ravi Anand wrote:
>> All,
>>
>> Today in the following email thread , Mike Christie outlined the 
>> modifications that has been done to qla4xx driver from the last submission: 
>>
>>> http://marc.theaimsgroup.com/?l=linux-scsi&m=115151443814051&w=2
> [...]
>> All the patches has been uploaded at the following URL:
>>
>> 	ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b6-k/
>>
>> Complete driver package and the diff from previous submission for review
>> has also been uploaded at the above mentioned link.
> [...]
> 
> Hi.
> 
> I'm not of much help in reviewing the code and/or making code
> suggestions.  Instead, I'm trying to build the driver as we've
> several new servers with ISP4010 adapters, which should work
> somehow... ;)
> 
> Except of the obvious prob wrt ql4_netlink.h file which you
> already fixed by subsequent patch.. well....
> 
> ....Ok.  I'm new in this area (just joined open-iscsi list).
> And my first question is: which [i]scsi implementation you
> were used as a base for this driver?
> 
> I've tried against curren open-iscsi svn repo, against
> scsi-misc kernel git tree, and against open-iscsi-1.0-485
> tarball.  Whch all are mostly similar (in API anyway).
> ql4 driver does not compile - even after "fixing" some
> "missing" #includes (like iscsi_if.h defining most of
> the ISCSI_* constants used in ql4_os.c), there are alot
> of functions missing (iscsi_{add,remove,free}_session()
> etc), undeclared structures used (*dscvr*) etc.

For the kernel code you need to get the scsi-misc tree (see
kernel.org/git for details). For the userspace tools you need the
open-iscsi.org svn tree with this patch

http://www.cs.wisc.edu/~michaelc/iscsi/open-iscsi/linux-scsi/tmp-qla4xxx-hook-into-userpace3.patch

For the userspace tools, we do not have the init scripts finished up so
you have to build the svn userspace tools, install them, then run

iscsid and iscsiadm by hand.

The iscsiadm command to run with qla4xxx is:

iscsiadm -m discovery -t st -a $host_no_of_qla4xxx_card -p
$discovery_address:$portal
