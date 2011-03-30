From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Wed, 30 Mar 2011 16:10:27 +0200
Message-ID: <4D9339D3.50500@suse.de>
References: <1301373398.2590.20.camel@mulgrave.site>	 <4D91BF90.8070909@redhat.com>	 <DBFB1B45AF80394ABD1C807E9F28D15702659CFFED@BLRX7MCDC203.AMER.DELL.COM>	 <20110329173338.GD24485@redhat.com>	 <DBFB1B45AF80394ABD1C807E9F28D15702659D0011@BLRX7MCDC203.AMER.DELL.COM>	 <20110329184501.GG24485@redhat.com>	 <DBFB1B45AF80394ABD1C807E9F28D15702659D0033@BLRX7MCDC203.AMER.DELL.COM>	 <20110329195953.GD21671@redhat.com>	 <DBFB1B45AF80394ABD1C807E9F28D15702659D004B@BLRX7MCDC203.AMER.DELL.COM>	 <20110329202353.GG21671@redhat.com>	 <DBFB1B45AF80394ABD1C807E9F28D15702659D00AB@BLRX7MCDC203.AMER.DELL.COM>	 <4D92C691.9070607@suse.de> <1301493722.2618.1.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1301493722.2618.1.camel@mulgrave.site>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Shyam_Iyer@dell.com, linux-scsi@vger.kernel.org, lsf@lists.linux-foundation.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 03/30/2011 04:02 PM, James Bottomley wrote:
> On Wed, 2011-03-30 at 07:58 +0200, Hannes Reinecke wrote:
>> On 03/30/2011 01:09 AM, Shyam_Iyer@dell.com wrote:
>>>
>>> Let me back up here.. this has to be thought in not only the tradit=
ional Ethernet
>>   >  sense but also in a Data Centre Bridged environment. I shouldn'=
t
>> have wandered
>>   >  into the multipath constructs..
>>>
>>> I think the statement on not going to the same LUN was a little err=
oneous. I meant
>>   >  different /dev/sdXs.. and hence different block I/O queues.
>>>
>>> Each I/O queue could be thought of as a bandwidth queue class being=
 serviced through
>>   >  a corresponding network adapter's queue(assuming a multiqueue
>> capable adapter)
>>>
>>> Let us say /dev/sda(Through eth0) and /dev/sdb(eth1) are a cgroup b=
andwidth group
>>   >  corresponding to a weightage of 20% of the I/O bandwidth the us=
er
>> has configured
>>   >  this weight thinking that this will correspond to say 200Mb of
>> bandwidth.
>>>
>>> Let us say the network bandwidth on the corresponding network queue=
s corresponding
>>   >  was reduced by the DCB capable switch...
>>> We still need an SLA of 200Mb of I/O bandwidth but the underlying d=
ynamics have changed.
>>>
>>> In such a scenario the option is to move I/O to a different bandwid=
th priority queue
>>   >  in the network adapter. This could be moving I/O to a new netwo=
rk
>> queue in eth0 or
>>   >  another queue in eth1 ..
>>>
>>> This requires mapping the block queue to the new network queue.
>>>
>>> One way of solving this is what is getting into the open-iscsi worl=
d i.e. creating
>>   >  a session tagged to the relevant DCB priority and thus the
>> session gets mapped
>>   >  to the relevant tc queue which ultimately maps to one of the
>> network adapters multiqueue..
>>>
>>> But when multipath fails over to the different session path then th=
e DCB bandwidth
>>   >  priority will not move with it..
>>>
>>> Ok one could argue that is a user mistake to have configured bandwi=
dth priorities
>>   >  differently but it may so happen that the bandwidth priority wa=
s
>> just dynamically
>>   >  changed by the switch for the particular queue.
>>>
>>> Although I gave an example of a DCB environment but we could defini=
tely look at
>>   >  doing a 1:n map of block queues to network adapter queues for
>> non-DCB environments too..
>>>
>> That sounds quite convoluted enough to warrant it's own slot :-)
>>
>> No, seriously. I think it would be good to have a separate slot
>> discussing DCB (be it FCoE or iSCSI) and cgroups.
>> And how to best align these things.
>
> OK, I'll go for that ... Data Centre Bridging; experiences, technolog=
ies
> and needs ... something like that.  What about virtualisation and ope=
n
> vSwitch?
>
Hmm. Not qualified enough to talk about the latter; I was more=20
envisioning the storage-related aspects here (multiqueue mapping,=20
QoS classes etc). With virtualisation and open vSwitch we're more in
the network side of things; doubt open vSwitch can do DCB.
And even if it could, virtio certainly can't :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
