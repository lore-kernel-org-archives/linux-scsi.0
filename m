From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between
 	different SCSI targets (SCST, STGT, IET, LIO)
Date: Thu, 09 Apr 2009 22:45:23 +0400
Message-ID: <49DE4243.5060004@vlnb.net>
References: <49D7AD54.4060408@vlnb.net> <49D7B122.50103@wpkg.org> <e2e108260904050429lcd1870ag6656f36a170ccab3@mail.gmail.com> <49D9D9A0.40106@wpkg.org> <49DA33EF.3020700@vlnb.net> <49DA49AA.1060106@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60323 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbZDISpT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2009 14:45:19 -0400
In-Reply-To: <49DA49AA.1060106@wpkg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, stgt@vger.kernel.org



Tomasz Chmielewski, on 04/06/2009 10:27 PM wrote:
> Vladislav Bolkhovitin schrieb:
> 
>>> Encrypted device was created with the following additional options 
>>> passed to cryptsetup
>>> (it provides the most performance on systems where CPU is a 
>>> bottleneck, but with decreased
>>> security when compared to default options):
>>>
>>> -c aes-ecb-plain -s 128
>>>
>>>
>>> Generally, CPU on the target was a bottleneck, so I also tested the 
>>> load on target.
>>>
>>>
>>> md0, crypt columns - averages from dd
>>> us, sy, id, wa - averages from vmstat
>>>
>>>
>>> 1. Disk speeds on the target
>>>
>>> Raw performance: 102.17 MB/s
>>> Raw performance (encrypted):  50.21 MB/s
>>>
>>>
>>> 2. Read-ahead on the initiator: 256 (default); md0, crypt - MB/s
>>>
>>>                            md0   us  sy  id  wa  | crypt   us  sy  id  
>>> wa  STGT                      50.63   4% 45% 18% 33% | 32.52    3% 62% 
>>> 16% 19%
>>> SCST (debug + no patches) 43.75   0% 26% 30% 44% | 42.05    0% 84%  1% 
>>> 15%
>>> SCST (fullperf + patches) 45.18   0% 25% 33% 42% | 44.12    0% 81%  2% 
>>> 17%
>>>
>>>
>>> 3. Read-ahead on the initiator: 16384; md0, crypt - MB/s
>>>
>>>                            md0   us  sy  id  wa  | crypt   us  sy  id  
>>> wa  STGT                      56.43   3% 55%  2% 40% | 46.90    3% 
>>> 90%  3%  4%
>>> SCST (debug + no patches) 73.85   0% 58%  1% 41% | 42.70    0% 85%  0% 
>>> 15%
>>> SCST (fullperf + patches) 76.27   0% 63%  1% 36% | 42.52    0% 85%  0% 
>>> 15%
>> Good! You proved that:
>>
>> 1. SCST is capable to work much better than STGT: 35% for md and 37% for 
>> crypt considering maximum values.
>>
>> 2. Default read-ahead size isn't appropriate for remote data access 
>> cases and should be increased. I slowly have been discussing it in past 
>> few months with Wu Fengguang, the read-ahead maintainer.
> 
> Note that crypt performance for SCST was worse than that of STGT for 
> large read-ahead values.
> Also, SCST performance on crypt device was more or less the same with 
> 256 and 16384 readahead values. I wonder why performance didn't increase 
> here while increasing readahead values?

This is a very big topic. In short, increasing RA alone isn't 
sufficient, because, while the bigger value transferred over the uplink, 
the backend storage can get rotated too far, so, to continue reading 
data from it, there will be a need to wait for that rotation completed.

Try together with the RA increase also decrease max_sectors_kb to 128K 
or even to 64K.

Also, the above actions done on the target can also be quite positive.

> Could anyone recheck if it's the same on some other system?
> 
>> Which IO scheduler on the target did you use? I guess, deadline? If so, 
>> you should try with CFQ as well.
> 
> I used CFQ.

You didn't apply io_context-XXX.patch, correct? With it you should see a 
  noticeable increase, like in http://scst.sourceforge.net/vl_res.txt.
