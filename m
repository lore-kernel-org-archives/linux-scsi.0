From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [regression] CD-DA delay needed after insertion
Date: Tue, 17 Jun 2008 18:56:06 -0400
Message-ID: <48584106.5000302@redhat.com>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be> <1213540781.3517.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758380AbYFQW4E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jun 2008 18:56:04 -0400
In-Reply-To: <1213540781.3517.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> On Fri, 2008-06-13 at 13:57 +0200, Geert Uytterhoeven wrote:
>> We've found another regression in 2.6.25 w.r.t. CD media change on PS3.
>>
>> It can easily be reproduced by:
>>
>>   1. Inserting an audio CD
>>   2. Running the following command as soon as the blue CD/DVD/BD drive LED
>>      stops blinking and is lit continuously:
>>       
>> 	 cdparanoia -Z -q 1-1[:1] /dev/null || echo failed
>>
>> On 2.6.25 (and current mainline), you have to wait ca. 10 seconds after
>> insertion, or it will fail.
>> On 2.6.24 and older, it just works immediately.
>>
>> It does not matter whether
>> http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fixes-2.6.git;a=commitdiff_plain;h=d1daeabf0da5bfa1943272ce508e2ba785730bf0
>> is applied or not.
>>
>> We haven't bisected it yet.
> 
> There aren't that many commits affecting sr between 2.6.24 and 2.6.25,
> so I'd bet on the previous culprits.
> 
> This time, the taxonomy looks like NOT_READY isn't being waited for
> properly.  I'd still tend to blame
> 210ba1d1724f5c4ed87a2ab1a21ca861a915f734 it's just that this time I
> suspect this to be the problem line:
> 

Looking at the last part of that commit, what code path could ever lead 
to reaching that last return statement and returning 
CDS_DRIVE_NOT_READY? Maybe I'm just being dense but it looks unreachable 
to me:

+	/*
+	 * If not using Mt Fuji extended media tray reports,
+	 * just return TRAY_OPEN since ATAPI doesn't provide
+	 * any other way to detect this...
+	 */
+	if (scsi_sense_valid(&sshdr) &&
+	    /* 0x3a is medium not present */
+	    sshdr.asc == 0x3a)
+		return CDS_NO_DISC;
+	else
+		return CDS_TRAY_OPEN;
+
+	return CDS_DRIVE_NOT_READY;
  }
