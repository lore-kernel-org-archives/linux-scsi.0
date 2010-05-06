From: brem belguebli <brem.belguebli@gmail.com>
Subject: Re: lpfc SAN/SCSI issue
Date: Thu, 6 May 2010 13:06:50 +0200
Message-ID: <z2x29ae894c1005060406l24d47eb8p7e97b6c5955bc259@mail.gmail.com>
References: <20100422164739.GA15813@lsil.com> <4BD1A071.2010202@emulex.com>
	 <j2o29ae894c1004230922le8baf635y563e50e3edc53bc3@mail.gmail.com>
	 <4BD226F4.6070908@emulex.com> <1272109999.2983.30.camel@localhost>
	 <4BD5D258.8030309@emulex.com> <1272318721.16254.7.camel@localhost>
	 <1272389874.4245.2.camel@localhost>
	 <k2w29ae894c1005030939lc95722dds328a2ee956b06ba1@mail.gmail.com>
	 <4BE17A27.5040603@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab0EFLGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2010 07:06:52 -0400
Received: by fxm10 with SMTP id 10so5007386fxm.19
        for <linux-scsi@vger.kernel.org>; Thu, 06 May 2010 04:06:51 -0700 (PDT)
In-Reply-To: <4BE17A27.5040603@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi James,


2010/5/5 James Smart <james.smart@emulex.com>:
>
>
> brem belguebli wrote:
>>
>> Hi james,
>>
>> We haven't yet been able to ask our Telco to switch back the DWDM
>> links to original situation.
>>
>> However, since logging was activated on the server I'm having a lot =
of
>> messages :
>>
>> lpfc 0000:10:00.1: 1:(0):0730 FCP command x26 failed: x2 SNS x700005=
00
>> x20000000 Data: xa x200 x10 x0 x0
>>
>> for which I couldn't find no explanation
>> (http://www-dl.emulex.com/support/linux/820482p/linux.pdf)
>>
>> Do you have any information on this ?
>
> This is saying that SCSI command opcode 0x26 (Vendor-specific opcode =
??)
> failed, with Status code x2 (Check Condition) followed by the SCSI se=
nse
> data, w/ Sense Key 5 (ILLEGAL REQUEST).
>
> I don't know who would be issuing this command (opcode 0x26), most li=
kely
> some utility/daemon using sgio, but the target is rejecting the comma=
nd (not
> valid for the vendor). =A0Very reasonable.
>
I could finally find the 730 messages explanation in your docs, and we
have tracked the faulty program.
It is hpasm which is shipped with the Proliant Support Pack, that we
invoque in the monitoring of the hardware RAID of the servers.
Actually the same program runs on similar (OS, HBA's, etc...) machines
without querying the opcode 0x26, and on 2 servers it does.
=46urther investigation on this pointed out that on these 2 servers, we
did install extra Emulex packages, elxocmlibhbaapi,
elxocmlibhbaapi-32bit and elxocmcore that install various libraries (
/usr/lib/libemsdm.so, /usr/lib/libdfc.so,/usr/lib/libnl.so.1) that
certainly contained symbols that are, thru the linux-gate.so, matched
in these 3 libs, making the above program (hpasm) querying opcode 0x26
on all the storage controllers on the system.
>
>> Also, there are other lpfc parameters that could be tweaked if I
>> understand well their meaning:
>>
>> lpfc_hba_queue_depth currently set to 1024 : =A0 Does it represent t=
he
>> number of [IOs/Exchanges] the HBA will queue untill the remote port
>> acks them or untill it is considered down ?
>
> This is the total number of i/o's outstanding on the wire, to all
> targets/luns, at any point in time. =A0This is typically the capacity=
 of the
> adapter, which is used in a FIFO basis as I/O is received from the mi=
dlayer.
> The default value of the attribute takes the maximum from the adapter=
=2E On
> your adapter, the value is 1024. On most newer adapters, it is 2x thi=
s or
> more. The only time I've seen this value tweaked is when our adapter =
is
> connected to a single target (array), and overruns or fully utilizes =
the
> capacity of the target, causing the target to work harder, and actual=
ly
> accomplish less, than it could at say an 80% utilization level (note:
> capacity level is target-specific). =A0 (another reason per-target qu=
eue_depth
> handling was put in - see next comment).
>
>
>>
>> lpfc_max_scsicmpl_time set to 0 : Does 0 represent some infinite
>> value, meaning it won't timeout any IO for which the driver did not
>> receive any completion ack ?
>
> No, unrelated. =A0This is relative to target queue depth mgmt. =A0The=
 midlayer
> doesn't do queue depth management by target - only per sdev (lun). Ou=
r
> driver does though. =A0Target queue depth is the sum of all i/o to al=
l luns on
> the same target, =A0with a threshold that may or may not be capped ba=
sed on
> the array type, and which scales/ramps down to the existing outstandi=
ng i/o
> count when the target reports QUEUE_FULL/TASK_SET_FULL. =A0This behav=
ior is
> valid only on targets that have a shared i/o queue for all luns. =A0T=
his value
> controls the per-target ramp-up processing. If 0, we use a constant
> compiled-in interval which ramps our target queue depth back up by x%=
=2E When
> non-zero, it specifies a shost-specific time interval for the ramp up=
 (it's
> actually a little trickier than this as it's tailored on some arrays =
that
> really depended upon not being overrun beyond their capacity levels).
>
Thanks for the explanation.

However, we do not have anymore x26 opcode error messages, though I
wasn't sure this was the root cause of the problem we had during the
DWDM ring failover, I increased the logging (0xffff) on the HBA's of
the nodes (total 4 nodes, 2 that were reporting the x26 opcode error
say Group A, and the 2 that never did, say Group B).
These 4 nodes form a cluster accessing the same LUNS thru the same
controllers the very same way, and I get errors relative to INQUIRY on
 Group A:

lpfc 0000:10:00.1: 1:(0):0730 FCP command x12 failed: x0 SNS x0 x0
Data: x8 x3c x0 x0 x0
lpfc 0000:10:00.1: 1:(0):0716 FCP Read Underrun, expected 96, residual
60 Data: x3c x12 x0
lpfc 0000:10:00.1: 1:0336 Rsp Ring 0 error: IOCB Data: xff000018
xe99fc48 x0 x0 x3c x0 x1d70c8e xa29b16
lpfc 0000:10:00.1: 1:0729 FCP cmd x12 failed <0/0> status: x1 result:
x3c Data: x1d7 xc8e
lpfc 0000:10:00.0: 0:(0):0730 FCP command x12 failed: x0 SNS x0 x0
Data: x8 x3c x0 x0 x0
lpfc 0000:10:00.0: 0:(0):0716 FCP Read Underrun, expected 96, residual
60 Data: x3c x12 x0
lpfc 0000:10:00.1: 1:0336 Rsp Ring 0 error: IOCB Data: xff000018
xe9960c0 x0 x0 x3c x0 x3360c67 xa29b16
lpfc 0000:10:00.1: 1:0729 FCP cmd x12 failed <0/0> status: x1 result:
x3c Data: x336 xc67

On both HBA's and concerning the 13 paths seen thru target 0 (<0/0>, <0=
/1>...)

Group B doesn't show no error.

I'm going to get on one of Group B node a HBA's change to make sure it
is not a hardware issue, and I'll keep you informed.


>
> -- james s
>
>
Regards

Brem
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
