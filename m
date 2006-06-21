From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] Print SCSI Inquiry data more compactly
Date: Wed, 21 Jun 2006 20:04:36 +0200
Message-ID: <44998A34.20202@s5r6.in-berlin.de>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0290B5BB@otce2k03.adaptec.com> <20060621164150.GM31472@vienna.egenera.com> <20060621165057.GW1630@parisc-linux.org> <1150909340.20655.37.camel@gator.sc.steeleye.com> <44997F73.7040903@emulex.com> <20060621173329.GZ1630@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:30402 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751131AbWFUSFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 14:05:22 -0400
In-Reply-To: <20060621173329.GZ1630@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Smart <James.Smart@Emulex.Com>, Eddie Williams <Eddie.Williams@steeleye.com>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Jun 21, 2006 at 01:18:43PM -0400, James Smart wrote:
>>scsi <2:0:1:0> x00:HP 18.2G:ATLAS10K3_18_SCA:HP05:02:
>>Eddie Williams wrote:
>>>scsi 2:0:1:0:DASD:HP 18.2G:ATLAS10K3_18_SCA:HP05:02:
> scsi 2:0:1:0: Direct-Access     HP 18.2G ATLAS10K3_18_SCA HP05 ANSI ver: 01 CCS
> scsi 2:0:1:0: Direct-Access     xAB HP 18.2G ATLAS10K3_18_SCA HP05 Level: 03
> scsi 2:0:1:0: Direct-Access     7 HP 18.2G ATLAS10K3_18_SCA HP05 Level: 03

All of these hurt eyes. What is wrong with the current two-line format?

One line too many? What about silencing protocol drivers first? sd puts 
out a lot of lines right after those inquiry data. What's more, sd is 
forced by some upper layer to go through the initialization twice, 
therefore sd sees fit to print its stuff out twice. This is where I see 
potential to reduce log noise.

Also keep in mind, the inquiry data in the syslog has been a source for 
users to feed the parameter scsi_mod.dev_flags. I.e. keep the vendor and 
model strings distinguishable.

And a beautiful layout of syslog messages is good for the mental peace 
of users.

Highly cryptic log messages on the other hand are about as valuable as 
_no_ log messages at all. The lines I quoted above are not far from 
white noise.

Again, what exactly is the gain from one log line less? The size of 
syslog files is taken care of by logrotate + gzip.

End of rant. :-)
-- 
Stefan Richter
-=====-=-==- -==- =-=-=
http://arcgraph.de/sr/
