From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: FC_PORTSPEED semantics confusion and zfcp regression
Date: Mon, 13 Aug 2012 19:17:58 +0200
Message-ID: <502936C6.2080404@linux.vnet.ibm.com>
References: <5023E206.2080104@linux.vnet.ibm.com> <739353123C992A4C8800D77E2094259046D72566@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:40589 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2HMRTR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2012 13:19:17 -0400
Received: from /spool/local
	by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Mon, 13 Aug 2012 18:19:16 +0100
Received: from d06av10.portsmouth.uk.ibm.com (d06av10.portsmouth.uk.ibm.com [9.149.37.251])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q7DHJ7gU21692460
	for <linux-scsi@vger.kernel.org>; Mon, 13 Aug 2012 17:19:07 GMT
Received: from d06av10.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av10.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q7DGoiPN032381
	for <linux-scsi@vger.kernel.org>; Mon, 13 Aug 2012 12:50:44 -0400
In-Reply-To: <739353123C992A4C8800D77E2094259046D72566@ORSMSX101.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Parikh, Neerav" <neerav.parikh@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Brattain, Ross B" <ross.b.brattain@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>, Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>

Hi Neerav,

thanks very much for your quick reply!

On 08/09/2012 09:29 PM, Parikh, Neerav wrote:
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Steffen Maier
>> Sent: Thursday, August 09, 2012 9:15 AM

>> Lately, commit
>> a9277e7783651d4e0a849f7988340b1c1cf748a4
>> "[SCSI] scsi_transport_fc: Getting FC Port Speed in sync with FC-GS"
>> reverted this.
>> (See also http://marc.info/?l=3Dlinux-scsi&m=3D132892310322550&w=3D2=
=2E)

> One thing that I seem to miss is the RPSC ELS have some different def=
initions
> for speed as compared to the FC_PORTSPEED before this commit as well.=
 Does the
> zfcp HBA FW do some internal conversion resulting into speed values t=
hat
> were in sync with the prior FC_PORTSPEED values?

Assuming you refer to the reversed bit order, then this is handled by=20
the HBA and therefore matches the prior FC_PORTSPEED values.

kernel before a9277e7                FC-GS RPSC ELS Sec.6.2.3.3.8+9
                                      Bit  Description
------------------------------------|------------------------------
#define FC_PORTSPEED_UNKNOWN      0  -
#define FC_PORTSPEED_1GBIT        1  15    1 Gb/s capable
#define FC_PORTSPEED_2GBIT        2  14    2 Gb/s capable
#define FC_PORTSPEED_4GBIT        4  13    4 Gb/s capable
#define FC_PORTSPEED_10GBIT       8  12   10 Gb/s capable
#define FC_PORTSPEED_8GBIT     0x10  11    8 Gb/s capable
#define FC_PORTSPEED_16GBIT    0x20  10   16 Gb/s capable
                                       9   20 Gb/s capable
                                       8   32 Gb/s capable
                                       7   40 Gb/s capable
                                      6-2  Reserved
                                       1   Unknown
#define FC_PORTSPEED_NOT_NEGOTIATED
                           (1 << 15)   0   Speed not established

>> I don't mind converting zfcp to an explicit finite bit
>> conversion based on individually defined constants, esp. since all
>> other
>> FC LLDDs (qla2xxx, bfa, lpfc, ibmvscsi, fnic, mptfc) seem to do so
>> already. The only slight drawback I can see is that the code needs t=
o
>> be touched for new HBA generations supporting new port speeds.

I think, I'm going to bring zfcp in line with the other LLDs and do an=20
explicit conversion for the following reasons:
Independence of any current kernel port speed semantics.
I have to do service for enterprise distros anyway (even if you revert=20
your commit upstream) since some seem to have to picked up a9277e7 alre=
ady.

>> 3) Should we have port speed defines for both RPSC ELS (in
>> include/fc/fc_els.h?) and FDMI port attributes (in
>> include/scsi/scsi_transport_fc.h? unless the bit semantic change get=
s
>> reverted)?
>>
>> This way I could reuse the former to convert to the latter within zf=
cp
>> and other users can reuse it with regard to RPSC ELS. I would send a
>> patch if we agree on this.

I guess, there is no other user currently so I might just code it insid=
e=20
zfcp without definitions in fc_els.h unless someone wants me to.

> Also, regardless of the approach you decide on wouldn't zfcp need to =
make
> sure the speed values reported by HBA FW is in sync with the in kerne=
l
> values?

Not necessarily, because we don't synchronize the bit semantics between=
=20
HBA and kernel, but between HBA and FC-GS RPSC ELS in reversed bit=20
order. If the kernel would also remain using the semantics of FC-GS RPS=
C=20
ELS in reversed bit order, then the HBA values would automatically matc=
h=20
the kernel definitions.
However, that's no longer relevant with an explicit conversion in zfcp.

Regards,
Steffen

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
