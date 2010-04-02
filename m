From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: ATA / mvsas issue.
Date: Thu, 01 Apr 2010 17:25:39 -0700
Message-ID: <4BB53983.5050309@cisco.com>
References: <53271.87.210.74.220.1270040583.squirrel@ketsers.dhs.org>    <7BF8FE1BFB7440B29ECD3D15FB0A4E8C@usish.com.cn>    <1068.77.248.79.78.1270102668.squirrel@ketsers.dhs.org>    <CDBC7B5488B245E689B39330542DC434@usish.com.cn> <1543.77.248.79.78.1270108509.squirrel@ketsers.dhs.org> <4BB50A92.3030205@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:61582 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab0DBAZk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 20:25:40 -0400
In-Reply-To: <4BB50A92.3030205@gmx.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: st0ff@npl.de
Cc: Caspar Smit <c.smit@truebit.nl>, jack wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org

Stefan *St0fF* Huebner wrote:
> Am 01.04.2010 09:55, schrieb Caspar Smit:
>>>     
>>>> Hi all,
>>>>
>>>> Today I installed 16 fresh Western Digital WD5000BEVT (2,5") drives in
>>>> one
>>>> of our test servers.
>>>>
>>>> I created a software raid5 with a hotspare on these 16 disks.
>>>>
>>>> I noticed that the detection of the disks during boottime was very very
>>>> slow.
>>>> Creating the md superblocks went very very slow.
>>>>
>>>> After that all seemed fine (speed of the raid5 init was normal).
>>>>
>>>> I noticed many of these messages in the syslog (also attached):
>>>>
>>>> Mar 31 14:34:17 test ata_id[3752]: main: HDIO_GET_IDENTITY failed for
>>>> '/dev/.tmp-8-112'
>>>> Mar 31 14:34:17 test ata_id[3765]: main: HDIO_GET_IDENTITY failed for
>>>> '/dev/.tmp-8-128'
>>>>
>>>> This seems to correspond to the slow detection of the disks.
>>>>
>>>> Is this an ATA problem, or a problem in the mvsas driver?
>>>>
>>>> I use the mvsas driver from 2.6.32 with the latest patch from Srinivas.
>>>>
>>>> Kind regards,
>>>> Caspar Smit
>>>>
>>>>
>>>> [Jack] It's normal behavior of SATA disk, SATA disk need more time than
>>>> SAS
>>>> disk to spin up to response command.
>>>>       
>>> I use loads of other SATA disks which don't have this behavior.
>>>
>>> Caspar
>>>
>>>
>>> [Jack] In my test, some big SATA disks(ie 500G above)have this issues.
>>> Best Regards
>>>     
> @Jack: sorry, but that doesn't cause unresponsiveness.  Some 2TB
> SATA-Disks need >10s to spin up, but there shouldn't be any notes/logs
> like those.  As a matter of fact: these 2,5" drives should spin up in a
> matter of 2s.

That seems to match the log that Caspar Smit posted yesterday.  Each drive
took about 2s to probe, and being that there are 16 of them, it took 32s.
It would be good if it could somehow do that in parallel being that this
is the 21st century :-)  Not sure how hard that is ...

I wonder if they spin up during probe or later during attach.

I don't know about the ata_id messages; I just wanted to point out the above.

Maybe ata_id is waiting for spin up but not waiting long enough if there are
so many disks and they spin up sequentially.  Spin up shouldn't be needed for
identity info, I would think.

	Joe

>> Seagate 500G SATA disks are working fine.
>>   
> Hitachi also.  And I've seen WD5000BEVT work great, too.  8 of a kind in
> a QNAP SS-839 (Atom based NAS with a pretty recent linux on it) work fine!
> 
> Stefan
>> Caspar
>>
>>   
>>> ************************************************************************
>>> Jack  Wang

