From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14579] Devices disappear; on bus reset machine hangs; on I/O
 machine hangs
Date: Wed, 18 Nov 2009 14:07:11 GMT
Message-ID: <200911181407.nAIE7B5r025674@demeter.kernel.org>
References: <bug-14579-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47185 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888AbZKROHF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 09:07:05 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAIE7B8H025675
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2009 14:07:11 GMT
In-Reply-To: <bug-14579-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14579





--- Comment #6 from lkolbe@techfak.uni-bielefeld.de  2009-11-18 14:07:10 ---
fyi


>From lkolbe@TechFak.Uni-Bielefeld.DE Wed Nov 18 14:39:08 2009
Date: Wed, 18 Nov 2009 14:39:09 +0100
From: Lukas Kolbe <lkolbe@TechFak.Uni-Bielefeld.DE>
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: Bug 14579 -  Devices disappear... and Bug 14577 - Data
    corruption with Adaptec
Message-ID: <20091118133909.GD16440@TechFak.Uni-Bielefeld.DE>
References: <20091111160220.GC5705@TechFak.Uni-Bielefeld.DE>
<20091112225825.GA20808@TechFak.Uni-Bielefeld.DE>
<0D1E8821739E724A86F4D16902CE275C1C93C04462@inbmail01.lsi.com>
<20091117142242.GA15638@TechFak.Uni-Bielefeld.DE>
<0D1E8821739E724A86F4D16902CE275C1C93C74A49@inbmail01.lsi.com>
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C93C74A49@inbmail01.lsi.com>

Desai, Kashyap wrote:

>> >Subject line is related to *Adaptec* and there are some places LSI
>> >related issue is pointed out. Little confusing to me. Is it possible to
>> >rewrite what is an issue related to LSI card?
>> 
>> Sorry for that one. This system has an Adaptec Controller for its
>> Storage array and an LSI controller for the tape library. Bug 14577 is
>> about a possible data corruption on 2.6.32-rc6 that seems to be either a
>> hardware error (currently trying to find that out) or a regression in
>> 2.6.32-rc6, as 2.6.30 is very happy with its storage.
>OK. In data corruption condition only LSI driver and controller are
>involved? I mean can I nullify Adaptec controller's roll in your test?

No, it is the other way round. We have 24 1TB Seagate harddisks
connected in a RAID 60 to the adaptec controller, and a Tandberg T80
with two IBM Ultrium-HH4 tape drives connected to the LSI controller.

The system is installed on an LVM volume within the RAID 60.
The data corruption occurs when we try to boot 2.6.32-rc6, we get write
errors and the boot process stops somewhere. So, it seems the data
corruption is related _only_ with the Adaptec Controller, the RAID array
or the harddisks.

>> Finally, the real problem here is Bug 14579 that is about the systems
>> problems when using the tape library.
>> 
>> >From dmesg log I can figure out 3.04.07 is mpt fusion driver version.
>> >Please update LSI driver using latest upstream driver version 3.04.13.
>> And see what a result is.
>> 
>> Thanks for the pointer. Linus' current tree contains 3.04.12 - where can
>> I find 3.04.13?
>
>It is there in 2.6.32-rc5. Not sure in which exact rc version it is
>included, but I have 2.6.32-rc5 tree in my setup and for that kernel
>mptfusion version is 3.104.13

Okay, I grep'ed for 3.04 in the source and only got one reference to the
older version number. But there lies the problem: Unless we can fix the
Adaptec-Bug first (or confirm it is a hardware issue), we can't boot
2.6.32-rc on that machine to test the new LSI driver version. Is it
easily possible to backport/include the mptfusion in 2.6.30?

Thanks for the help and kind regards, 
-- 
Lukas Kolbe

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
