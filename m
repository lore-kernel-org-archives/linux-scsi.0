From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] printks in print_inquiry
Date: Fri, 19 May 2006 15:43:26 -0400
Message-ID: <446E1FDE.1080404@emulex.com>
References: <20060511150015.GJ12272@parisc-linux.org> <20060512170854.GA11215@us.ibm.com> <20060513050059.GR12272@parisc-linux.org> <20060518183652.GM1604@parisc-linux.org> <20060518200957.GA29200@us.ibm.com> <20060519190848.GA2826@parisc-linux.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:10372 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750938AbWESTnc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 15:43:32 -0400
In-Reply-To: <20060519190848.GA2826@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org



Matthew Wilcox wrote:
> On Thu, May 18, 2006 at 01:09:57PM -0700, Patrick Mansfield wrote:
>>> scsi: 2:0:1:0: Vendor: HP 18.2G Model: ATLAS10K3_18_SCA Rev: HP05 ANSI rev: 02  
>> That is very nice ... as is replacing print_inquiry with one line of code.
> 
> Thanks.  However, I'm now wondering about the length of the line.
> Aren't people agitating to replace the channel with a string?  which
> could be longer than the, oh, three bytes left after the end of the
> current string?  Losing the scsi: isn't really a good idea.  So how
> about:
> 
> scsi: 2:0:1:0 Device: HP 18.2G ATLAS10K3_18_SCA HP05 ANSI 02
> scsi: 4:0:2:0 Device: HP       DVD-ROM 305      1.01 ANSI 02
> 
> If we really wanted to be smart, we could even do:
> 
> scsi: 2:0:1:0 Direct-Access      HP 18.2G ATLAS10K3_18_SCA HP05 ANSI 02
> scsi: 4:0:2:0 CD-ROM             HP       DVD-ROM 305      1.01 ANSI 02

I wouldn't bother with the device type, unless you are reporting it as the
byte0 contents (eg. PQ bits and dev type). I would like to see the PQ bits.
I also expect the class driver to typically bind to the device right after
this, so I'll get the sd or st lines which will further reflect device type.

> I'm still in two minds about even reporting the ANSI version.  Is there
> ever a time when having that information would be useful to debug a
> problem *and* we don't have access to that (eg through sysfs)?

It makes a difference if debugging a scan issue. I would think it's useful
to see what Lun 0 has as it drives other scanning.

-- james s
