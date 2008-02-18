From: Erez Zilber <erezz@Voltaire.COM>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 18 Feb 2008 11:43:31 +0200
Message-ID: <47B95343.9060802@Voltaire.COM>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	 <1201639331.3069.58.camel@localhost.localdomain>	 <adazluoe2t3.fsf@cisco.com>	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>	 <47A89660.1080804@Voltaire.COM> <e2e108260802060416w492db372mc09848edd365d441@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:18298 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751368AbYBRJnh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 04:43:37 -0500
In-Reply-To: <e2e108260802060416w492db372mc09848edd365d441@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> On Feb 5, 2008 6:01 PM, Erez Zilber <erezz@voltaire.com> wrote:
>   
>> Using such large values for FirstBurstLength will give you poor
>> performance numbers for WRITE commands (with iSER). FirstBurstLength
>> means how much data should you send as unsolicited data (i.e. without
>> RDMA). It means that your WRITE commands were sent without RDMA.
>>     
>
> Sorry, but I'm afraid you got this wrong. When the iSER transport is
> used instead of TCP, all data is sent via RDMA, including unsolicited
> data. If you have look at the iSER implementation in the Linux kernel
> (source files under drivers/infiniband/ulp/iser), you will see that
> all data is transferred via RDMA and not via TCP/IP.
>
>   

When you execute WRITE commands with iSCSI, it works like this:

EDTL (Expected data length) - the data length of your command

FirstBurstLength - the length of data that will be sent as unsolicited
data (i.e. as immediate data with the SCSI command and as unsolicited
data-out PDUs)

If you use a high value for FirstBurstLength, all (or most) of your data
will be sent as unsolicited data-out PDUs. These PDUs don't use the RDMA
engine, so you miss the advantage of IB.

If you use a lower value for FirstBurstLength, EDTL - FirstBurstLength
bytes will be sent as solicited data-out PDUs. With iSER, solicited
data-out PDUs are RDMA operations.

I hope that I'm more clear now.

Erez
