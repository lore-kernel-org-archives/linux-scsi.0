From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 09/11] iscsi_transport: Added Ping support
Date: Tue, 21 Feb 2012 16:58:34 -0600
Message-ID: <4F44219A.6070207@cs.wisc.edu>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>	<1329138050-1042-10-git-send-email-vikas.chaudhary@qlogic.com>	<CAJZOPZLdXtdLyTstWLu8A1Q454LD4k-0+HoDdqEHwFzbs+Ro6g@mail.gmail.com>	<4F441BC5.4000301@cs.wisc.edu> <CAJZOPZKo5O8GMO9dz09UAvX8gHd5bT-Y2MdRkckh9dv2Q=m1jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41280 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab2BUW6K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 17:58:10 -0500
In-Reply-To: <CAJZOPZKo5O8GMO9dz09UAvX8gHd5bT-Y2MdRkckh9dv2Q=m1jA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: vikas.chaudhary@qlogic.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com

On 02/21/2012 04:39 PM, Or Gerlitz wrote:
> On Wed, Feb 22, 2012 at 12:33 AM, Mike Christie <michaelc@cs.wisc.edu> wrote:
>> This is network based. ICMP pings. The stuff we have today is iscsi
>> based pings. So you can do some basic network diag type of stuff.
> 
> So what's wrong with plain ICMP pings... or is this is for
> cards/drivers which don't expose plain network interface to the
> kernel?

Yeah, the latter. There is a network driver for the card, but the
networking stack is completely different for the 2 functions. The
network driver is a normal old net device driver. Then for the iscsi
function they basically have a complete network stack in fw. The
networking settings for the 2 functions are going to be separate. So the
iscsi function port has a different ip and MAC than the network driver
one. The ip could then be on different subnets, different vlans, etc. So
you might not be able to reach the target from the normal network driver
net device.
