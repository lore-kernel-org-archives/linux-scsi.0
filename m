From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: target: Question about transport_generic_allocate_tasks()
Date: Sun, 13 Feb 2011 12:40:22 +0100
Message-ID: <AANLkTimGj=OK3=x_+d2VuStLSMtXoDBXDf=ZKx2EJ8r7@mail.gmail.com>
References: <AANLkTi=HhpMKKW6J7R5GR2yQ_V=222TeR1KKRpUp-Z0V@mail.gmail.com>
	<1297541427.13306.48.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41520 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab1BMLkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2011 06:40:23 -0500
Received: by iwn9 with SMTP id 9so3896425iwn.19
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2011 03:40:22 -0800 (PST)
In-Reply-To: <1297541427.13306.48.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Feb 12, 2011 at 9:10 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On Sat, 2011-02-12 at 15:33 +0100, Fubo Chen wrote:
>> Target drivers assume that transport_generic_allocate_tasks() return=
s
>> 0, -1 or -2. But if transport_generic_allocate_tasks() invoks
>> transport_generic_cmd_sequencer() and if
>> transport_generic_cmd_sequencer() invokes core_alua_state_check() th=
e
>> value 1 can be returned. Which is correct - drivers or core ? And wh=
at
>> is meaning of return values ?
>>
>
> Hi Fubo,
>
> Note that when 'ret =3D T10_ALUA(su_dev)->alua_state_check(...)' is n=
on
> zero, there are two possible cases:
>
> *) transport_generic_cmd_sequencer() will still 'return -2' when the
> =A0 (ret > 0) check is true from ->alua_state_check(...)
>
> *) Or jump to the label out_invalid_cdb_field: that also will
> =A0 'return -2'.
>
> So AFAICT transport_generic_cmd_sequencer() will never actually
> 'return ret' when 'ret =3D 1';

Thanks for all help. I think other kernel code uses enum { } to assign
name to return values.

=46ubo.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
