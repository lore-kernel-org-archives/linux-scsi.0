From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Subject: RE: State of big-endian for MegaRAID SAS driver
Date: Mon, 26 Aug 2013 12:51:07 +0530
Message-ID: <088E451FE1854947BD9145EF8C016FF413A017BC30@inbmail01.lsi.com>
References: <658ABE5F-B2AA-4EC1-BC34-B4FD428C7A8E@servergy.com>
 <yq1zjskgn1x.fsf@sermon.lab.mkp.net>
 <D354E621-BEFA-4010-B5CF-4668939AAEB0@servergy.com>
 <yq1eh9wgiqo.fsf@sermon.lab.mkp.net>
 <FE68512D-F375-456B-948A-492634A02F0F@servergy.com>
 <yq1haeqcuce.fsf@sermon.lab.mkp.net>
 <088E451FE1854947BD9145EF8C016FF413A017B456@inbmail01.lsi.com>
 <3DA40821-A3AC-45CA-BD22-995EA256837A@servergy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:7978 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755317Ab3HZHVT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Aug 2013 03:21:19 -0400
In-Reply-To: <3DA40821-A3AC-45CA-BD22-995EA256837A@servergy.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <ben.c@servergy.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, "aradford@gmail.com" <aradford@gmail.com>, "Maloy, Joe" <Joe.Maloy@lsi.com>



>-----Original Message-----
>From: Ben Collins [mailto:ben.c@servergy.com]
>Sent: Monday, August 19, 2013 10:55 PM
>To: Saxena, Sumit
>Cc: Martin K. Petersen; DL-MegaRAID Linux; linux-scsi;
>aradford@gmail.com
>Subject: Re: State of big-endian for MegaRAID SAS driver
>
>On Aug 19, 2013, at 7:16 AM, "Saxena, Sumit" <Sumit.Saxena@lsi.com>
>wrote:
>> This patch: Big endian support for megaraid_sas driver is not
>complete. In few areas, we need to do changes like this patch does not
>have changes for Thunderbolt/invader/Fury controllers(file:
>megaraid_sas_fusion.c), and needs few changes in file:
>megaraid_sas_fp.c(while host reads some member of raidmap, it needs
>endianness change there also)..
>>
>> LSI has megaraid_sas driver with big endian support for driver version
>"06.506.00.00". But to add big endian support for latest upstream
>megaraid_sas driver (06.600.18.00), we need to make some more changes.
>> We will get back with big endian support patch on top of latest
>upstream megaraid_sas driver.
>>
>
>Is this work-in-progress available somewhere? What is the time frame you
>expect to have this supported by LSI directly? Based on the fact that
>big-endian support in megaraid_sas is 8 years in the making, forgive me
>if I'm a little skeptical of progress in the near term.
>
 
We are conferring with Marketing and Product Management on direction  wrt  Big endian support for megaraid_sas driver.  Our goal is to gain clear direction within two weeks.

>I realize that the big-endian patch from Martin isn't complete for
>fusion, but it is for other cards. Given that our company has a POWER
>based product using MegaRAID LSI SAS due on the market in a matter of
>months, I'd like to have stock kernels supporting it sooner rather than
>later.
>
>Since this patch has zero effect on currently supported platforms
>(little-endian), I don't see the harm in letting it through, since it
>actually does work, and more importantly, works right now.
>

Martin's patch does not have few changes needed in function "megasas_init_fw()"(inside file: megaraid_sas_base.c), so for consistency and driver's maintenance point of view- big endian support should be committed with complete set of changes, which works for all generation controllers.

>>> -----Original Message-----
>>> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
>>> Sent: Friday, August 16, 2013 6:42 AM
>>> To: Ben Collins
>>> Cc: Martin K. Petersen; DL-MegaRAID Linux; linux-scsi;
>>> aradford@gmail.com
>>> Subject: Re: State of big-endian for MegaRAID SAS driver
>>>
>>>>>>>> "Ben" == Ben Collins <ben.c@servergy.com> writes:
>>>
>>> Ben,
>>>
>>> Ben> Considering your patch has had two success stories (I suspect
>>> Ben> yours was on SPARC, so that would even make two different
>>> Ben> platforms) and low likelihood of regression on little endian, I
>>> Ben> think it's pretty safe.
>>>
>>> I ordered a MegaRAID card today so I can test on x86 just to be sure.
>>>
>>>
>>> Ben> The only thing I think that could make it better is to annotate
>>> Ben> the structures in megaraid_sas.h as __le32 where applicable.
>>>
>>> I have an older patch that does just that. And another one that gets
>>> rid of the 32-bit DMA limitations on large systems. But I didn't want
>>> to clutter the initial submission.
>>>
>>> --
>>> Martin K. Petersen	Oracle Linux Engineering
>>
>>
>
>--
>Benjamin M. Collins | Principal Architect Servergy, Inc. | Save Energy.
>Work Smart. (r) m (757) 243-7557 | e ben.c@servergy.com L LinkedIn | T
>twitter.com/Servergy www.servergy.com
>
>CONFIDENTIALITY NOTICE: This communication contains privileged and/or
>confidential information to be maintained with the strictest confidence.
>It is intended solely for the use of the person or entity in which it is
>addressed. If you are not the intended recipient, you are STRICTLY
>PROHIBITED from disclosing, copying, distributing or using any of this
>information. If you received this communication in error, please contact
>the sender immediately and destroy the material in its entirety, whether
>electronic or hard copy.  Email may contain forward looking comments
>that are based on managements best-faith estimates which are subject to
>change. For information only. Not an offer, or solicitation of any offer
>to buy or sell any security, investment or other product.
>


