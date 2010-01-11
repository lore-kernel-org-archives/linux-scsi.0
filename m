From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
Date: Mon, 11 Jan 2010 21:18:02 +0100
Message-ID: <4B4B877A.8060106@googlemail.com>
References: <5543f88f1001111129u362be554kd97027d977b5dff3@mail.gmail.com> <5543f88f1001111141r5375d2a3kd726d2b70e124b94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754236Ab0AKURk@vger.kernel.org>
In-Reply-To: <5543f88f1001111141r5375d2a3kd726d2b70e124b94@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Bejarano <beej@beej.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

On 01/11/10 20:41, Marc Bejarano wrote:
> and once more in plain text.  (sorry vger)
>
> 2010/1/11 Marc Bejarano<beej@beej.org>:
>> oops.  seems that GMANE's reply function only goes to a single "news=
group".
>>   original recipients re-added.
>> marc
>> ----
>> From: Marc Bejarano<beej<at>  beej.org>
>> Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
>> Newsgroups: gmane.linux.scsi
>> Date: 2010-01-08 22:21:09 GMT (2 days, 20 hours and 40 minutes ago)
>>
>> Ren=E9 Bolldorf<xsecute<at>  googlemail.com>  writes:
>>> On 01/08/10 16:28, James Bottomley wrote:
>>>> On Thu, 2010-01-07 at 14:15 -0500, Jeff Garzik wrote:
>>>>> On 12/30/2009 05:59 PM, Ren=E9 Bolldorf wrote:
>>>>>> We don't need this .
>>
>>>>>> - /* FIXME: is this needed? */
>>>>>> - memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
>>>>>
>>>>> I need a little bit more detail than an unqualified statement... =
 Did
>>>>> you audit all paths leading to this code point?
>>
>>>> But one also here:
>>>>
>>>> u8 *sense_buffer =3D dev->link->ap->sector_buf;
>>>> [...]
>>>> err_mask =3D atapi_eh_request_sense(dev, sense_buffer, sense_key);
>>>>
>>>> Which doesn't look OK because it looks like the sector_buf isn't c=
leared
>>>> (and it is reused).
>>>>
>>>> James
>>>>
>>>>
>>>
>>> Thank's, you're right. I have overseen this, sry for that.
>>
>> Ren=E9: perhaps you'd like to submit a patch that substitutes FIXME =
comment
>> for one that explains why the memset is needed, crediting James in t=
he
>> description?  we may as well gain something permanent from this disc=
ussion
>> that you started :)
>>
>> cheers,
>> marc
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo<at>  vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> ----

I hope that's good enough explained :-).

Best regards
Ren=E9

--- ./drivers/ata/libata-eh.c   2010-01-07 23:21:23.622464012 +0100
+++ ./drivers/ata/libata-eh.c   2010-01-11 21:11:19.869092897 +0100
@@ -1505,7 +1505,10 @@ static unsigned int atapi_eh_request_sen

         DPRINTK("ATAPI request sense\n");

-       /* FIXME: is this needed? */
+       /* make sure sense_buf is cleared then atapi_eh_request_sense i=
s=20
called.
+        * (to make sure nothing get's reused.)
+        * thanks to James Bottomley
+        */
         memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);

         /* initialize sense_buf with the error register,
