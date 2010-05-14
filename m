From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 5/7] lpfc 8.3.13: BSG management fixes
Date: Fri, 14 May 2010 09:46:16 -0400
Message-ID: <4BED5428.8090703@emulex.com>
References: <1273671164.24670.21.camel@wookie> <20100514183051S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:24308 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753055Ab0ENNqn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2010 09:46:43 -0400
In-Reply-To: <20100514183051S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

Slightly different. I believe it's ok relative to when there's a BSG request 
in flight. But in this case there isn't, but there is a program w/ the bsg 
node open, and the driver/transport/etc can all be unloaded as bsg_open 
doesn't take a reference anywhere.

I look at it the other day, and it appears to be an issue with bsg itself. It 
should just take a reference to the bsg class dev in open, and release it in 
release. But the bsg_unregister_queue() path doesn't track whether the node 
was open or not and the teardown needs to be split up so that it really is 
reference based.

-- james s


FUJITA Tomonori wrote:
> On Wed, 12 May 2010 09:32:14 -0400
> James Smart <james.smart@emulex.com> wrote:
> 
>> - Add reference counting to prevent module removal when
>>   there are outstanding BSG requests.
> 
> Didn't I worked on it about scsi_transport_sas?
> 
> bsg holds the ref count on the device that passed in
> bsg_register_queue() while there are outstanding bsg requests. It is
> supposed to prevent the module of the hold device from be removed.
> 
> Do you get the oops message?
> 
