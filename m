From: Hannes Reinecke <hare@suse.de>
Subject: Re: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan
 in the middle
Date: Tue, 22 Oct 2013 19:05:43 +0200
Message-ID: <5266B067.7020207@suse.de>
References: <525AD704.6040705@oracle.com> <525BD1EA.6000701@suse.de> <525BE8C1.5090606@linux.vnet.ibm.com> <525BEF2B.2030907@suse.de> <525BF256.6060707@suse.de> <525C0CAE.3030803@linux.vnet.ibm.com> <525E37CA.2000605@suse.de> <5264C48A.80900@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5264C48A.80900@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vaughan <vaughan.cao@oracle.com>, Steffen Maier <maier@linux.vnet.ibm.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/21/2013 08:07 AM, vaughan wrote:
> On 10/16/2013 02:52 PM, Hannes Reinecke wrote:
>> But seeing that this approach raises quite some issues I've attached=
 a
>> different patch. Vaughan, could you test with that, too? Should be
>> functionally equivalent to the previous one. Cheers, Hannes
> Hi Hannes,
>
> We only tested the later patch which returns _TARGET_PRESENT after
> parsing sense, it works as expected.
>
> About the cause of this issue, admin said he is configuring a
> active-active cluster mode storage. Each node has it own LUN pool and=
 a
> set of rule to control which node can access the pool.
> LUN7 is owned and can only be able to manipulated by the other node, =
but
> can be seen by this node for a misconfig. So it presents itself in
> REPORT_LUN but return NOT_READY when accessed through this node.
> Do you still regard this as a misbehave in response to INQUIRY?
>
Yes. INQUIRY _has_ to succeed. The only exceptions here would be device=
s=20
in 'Offline' state.
But other that that, yes, INQUIRY should never abort with an error,=20
especially for ALUA.
ALUA relies on 'report target port groups' and INQUIRY EVPD page 0x83 t=
o=20
identify the target port group state.
So if INQUIRY does _not_ work you cannot figure out the ALUA state,
and by rights you would need to disable ALUA there.


Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
