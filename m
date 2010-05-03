From: brem belguebli <brem.belguebli@gmail.com>
Subject: Re: lpfc SAN/SCSI issue
Date: Mon, 3 May 2010 18:39:41 +0200
Message-ID: <k2w29ae894c1005030939lc95722dds328a2ee956b06ba1@mail.gmail.com>
References: <20100422164739.GA15813@lsil.com>
	 <1271964275.2480.1.camel@localhost> <4BD1A071.2010202@emulex.com>
	 <j2o29ae894c1004230922le8baf635y563e50e3edc53bc3@mail.gmail.com>
	 <4BD226F4.6070908@emulex.com> <1272109999.2983.30.camel@localhost>
	 <4BD5D258.8030309@emulex.com> <1272318721.16254.7.camel@localhost>
	 <1272389874.4245.2.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53430 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004Ab0ECQjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2010 12:39:43 -0400
Received: by fxm10 with SMTP id 10so2297915fxm.19
        for <linux-scsi@vger.kernel.org>; Mon, 03 May 2010 09:39:42 -0700 (PDT)
In-Reply-To: <1272389874.4245.2.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org

Hi james,

We haven't yet been able to ask our Telco to switch back the DWDM
links to original situation.

However, since logging was activated on the server I'm having a lot of
messages :

lpfc 0000:10:00.1: 1:(0):0730 FCP command x26 failed: x2 SNS x70000500
x20000000 Data: xa x200 x10 x0 x0

for which I couldn't find no explanation
(http://www-dl.emulex.com/support/linux/820482p/linux.pdf)

Do you have any information on this ?

Also, there are other lpfc parameters that could be tweaked if I
understand well their meaning:

lpfc_hba_queue_depth currently set to 1024 :   Does it represent the
number of [IOs/Exchanges] the HBA will queue untill the remote port
acks them or untill it is considered down ?

lpfc_max_scsicmpl_time set to 0 : Does 0 represent some infinite
value, meaning it won't timeout any IO for which the driver did not
receive any completion ack ?

Thanks

Brem




2010/4/27 brem belguebli <brem.belguebli@gmail.com>:
> Hi James,
>
> I could set lpfc_log_verbose on both HBA's to 4115, I hope it'll be h=
igh
> enough to get interesting traces.
>
> On Mon, 2010-04-26 at 23:52 +0200, brem belguebli wrote:
>> Hi James,
>>
>> On Mon, 2010-04-26 at 13:50 -0400, James Smart wrote:
>> > Brem,
>> >
>> > I'm not understanding you.
>> >
>> >
>> > brem belguebli wrote:
>> > > We have sg3_utils installed , and I think we ran sg_verify on on=
e or
>> > > 2
>> > > unresponsive /dev/sd and it didn't give the hand back.
>> > >
>> > what do you mean "give the hand back" ? =A0 =A0was the operation
>> > successful or not ?
>> >
>> When I say it didn't give the hand back, I mean the one or 2 process=
es
>> got stuck in D state, thus not returning success .
>> > > It was exactly
>> > > cd /sys/block
>> > > for DEV in `ls -1d dev*`; do
>> > > echo ${DEV}
>> > > =A0 =A0 =A0 =A0 dd if =3D/dev/${DEV} of=3D/dev/null bs=3D1024 co=
unt=3D1 &
>> > > =A0 =A0 =A0 =A0 echo
>> > > done
>> > >
>> > > And yes it really works, never seen any kind of preemption of DM=
-MP over
>> > > direct sd access. I've cc'ed dm-devel may be some DM guru could =
give his
>> > > opinion on this.
>> > >
>> > > Next time, I'll use a sg_dd instead of dd, to bypass any cache e=
ffect
>> > > (by the way, does VFS cache anything when addressing /dev/X devi=
ces ?)
>> > >
>> > ok - by "works" means "dd successfully read 1 block from the devic=
e" -
>> > right ?
>> >
>> Yes, the devices on which dd was successful were the ones from FABRI=
C1,
>> dd completed successfully by reading the first 1024 bytes to copy th=
em
>> to /dev/null
>>
>> > > > The most interesting for the lpfc driver would be the lpfc mod=
ule
>> > > > parameter "lpfc_log_verbose=3D4115"
>> > > > which turns on discovery log messages, els messages, link even=
ts, and
>> > > > FCP i/o error messages.
>> > > >
>> > >
>> > > As our DWDM ring switch is on the less optimal path, there will =
be a
>> > > switch back to nominal soon.
>> > >
>> > > I'll activate this log level on the HBA's and check the firmware
>> > > versions you gave me .
>> > >
>> > ok. I believe that the shost for the adapters in question, have a
>> > sysfs variable for lpfc_log_verbose, that sets the log level on th=
e
>> > individual adapter. This would not require you to unload/reload th=
e
>> > driver to set the option.
>> >
>> I'll tell you tomorrow (was off today) if the parameter exists for t=
hese
>> HBA's.
>
>
>> > > Hopefully, we will be able to provide you something deeper to
>> > > investigate.
>> > >
>> > > Brem
>> > >
>> >
>> > ok.
>> >
>> > -- james
>> >
>> >
>> Thanks
>>
>>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
