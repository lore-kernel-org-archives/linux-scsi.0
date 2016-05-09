From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Mon, 9 May 2016 11:35:54 +1000
Message-ID: <CAGRGNgVYdamHZcpz6tPFK8brjNjDjytBrtjZzxb9c8+Kw7H9rg@mail.gmail.com>
References: <1462668011.32105.7.camel@petros-ultrathin> <alpine.LNX.2.00.1605081235490.19865@nippy.intranet>
 <1462709320.2840.15.camel@petros-ultrathin> <alpine.LNX.2.00.1605082216090.19865@nippy.intranet>
 <1462725247.6614.3.camel@petros-ultrathin>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:36322 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbcEIBgP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 May 2016 21:36:15 -0400
Received: by mail-oi0-f52.google.com with SMTP id x201so195184908oif.3
        for <linux-scsi@vger.kernel.org>; Sun, 08 May 2016 18:36:14 -0700 (PDT)
In-Reply-To: <1462725247.6614.3.camel@petros-ultrathin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Petros Koutoupis <petros@petroskoutoupis.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, megaraidlinux.pdl@avagotech.com, linux-scsi <linux-scsi@vger.kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>

Hi Petros,

On Mon, May 9, 2016 at 2:34 AM, Petros Koutoupis
<petros@petroskoutoupis.com> wrote:
> On Sun, 2016-05-08 at 22:22 +1000, Finn Thain wrote:
>> On Sun, 8 May 2016, Petros Koutoupis wrote:
>>
>> > >
>> > > That contains a tautology.
>> > >
>> >
>> > How so?
>>
>> if (x)
>>       /* ... */
>> else if (!x && (whatever))
>>       /* ... */
>>
>> --
>
> Thank you but I know the logic of what I wrote. A tautology
> will yield the same results no matter what the interpretation.
> That is not a tautology. The two conditionals in my case check
> different states and serve different purposes.

You're missing the point.

Execution will only reach the else branch if "!cmd_fusion->scmd",
hence checking that is unnecessary. Removing that test (and all the
unnecessary parentheses) will reduce the second test to:

else if (scsi_io_req->Function == MPI2_FUNCTION_SCSI_IO_REQUEST ||
        scsi_io_req->Function == MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST)

which is much cleaner.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
