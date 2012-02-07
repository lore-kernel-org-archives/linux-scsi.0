From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: FireWire/SBP2 Target mode
Date: Tue, 7 Feb 2012 21:06:57 +1100
Message-ID: <CAGRGNgXj37g6Q5W+hwkBjQHh3a8to+2Vq5Yx_omC8p9bdZrdBw@mail.gmail.com>
References: <4E4BD560.4010806@bootc.net> <4E4D3B88.30003@ladisch.de>
 <4F29978A.3010707@redhat.com> <20120201224156.0773ebc6@stein>
 <4F2A55B9.4040005@panasas.com> <4F2A60DC.9030007@ladisch.de>
 <4F2FD1F4.9050702@bootc.net> <4F2FE705.3070509@ladisch.de>
 <4F2FE8DA.70502@bootc.net> <20120206212628.6880c506@stein>
 <5C167A1D-2203-4F1C-B538-E99DD87E7E42@bootc.net> <CAGRGNgWf0epcam-jpCzMCSqefCKDSm892mw-X49FrcoRO0QYrQ@mail.gmail.com>
 <476E7976-738A-4202-9FC4-FA5B060EA95F@bootc.net> <4F30D4F6.1040802@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <4F30D4F6.1040802@bootc.net>
Sender: target-devel-owner@vger.kernel.org
To: Chris Boot <bootc@bootc.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Clemens Ladisch <clemens@ladisch.de>, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Boaz Harrosh <bharrosh@panasas.com>, Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Tue, Feb 7, 2012 at 18:38, Chris Boot <bootc@bootc.net> wrote:
> On 06/02/2012 23:09, Chris Boot wrote:
>>
>>
>> On 6 Feb 2012, at 23:00, Julian Calaby wrote:
>>
>>> Hi,
>>>
>>> On Tue, Feb 7, 2012 at 09:28, Chris Boot<bootc@bootc.net> =A0wrote:
>>>>
>>>> On 6 Feb 2012, at 20:26, Stefan Richter wrote:
>>>>
>>>>> On Feb 06 Chris Boot wrote:
>>>>>>
>>>>>> On 06/02/2012 14:43, Clemens Ladisch wrote:
>>>>>>>
>>>>>>> Chris Boot wrote:
>>>>>>>>
>>>>>>>> You can pull the code from:
>>>>>>>> git://github.com/bootc/Linux-SBP-2-Target.git
>>>>>>>
>>>>>>>
>>>>>>> The TODO file says:
>>>>>>>>
>>>>>>>> * Update Juju so we can get the speed in the fw_address_handle=
r
>>>>>>>> callback
>>>>>>>
>>>>>>>
>>>>>>> What is the speed needed for?
>>>>>>
>>>>>>
>>>>>> "The speed at which the block write request to the MANAGEMENT_AG=
ENT
>>>>>> register is received shall determine the speed used by the targe=
t for
>>>>>> all subsequent requests to read the initiator=92s configuration =
ROM,
>>>>>> fetch
>>>>>> ORB=92s from initiator memory or store status at the initiator=92=
s
>>>>>> status_FIFO. Command block ORB=92s separately specify the speed =
for
>>>>>> requests addressed to the data buffer or page table."
>>>>>>
>>>>>> (T10/1155D Revision 4 page 53/54)
>>>>>
>>>>>
>>>>> I guess it is not too hard to add this to the AR-req handler. =A0=
On the
>>>>> other hand, I see little reason to follow the SBP-2 spec to the l=
etter
>>>>> here. =A0The target driver could just use the maximum speed that =
the core
>>>>> figured out. =A0On the other hand, this requires of course
>>>>> =A0- the target to wait for core to finish scanning an initiator,
>>>>> =A0- the core to offer an API to look up an fw_device by a
>>>>> =A0 =A0card--generation--nodeID tuple.
>>>>>
>>>>> The intention of the spec is IMO clearly to enable target
>>>>> implementations
>>>>> that do not need to implement topology scanning. =A0I have a hard=
 time to
>>>>> think of a valid scenario where an initiator needs to be able to =
steer
>>>>> a
>>>>> target towards a lower wire speed than what the participating lin=
ks and
>>>>> PHYs actually support.
>>>>
>>>>
>>>> The only thing stopping me from getting the speed is the fact that
>>>> struct fw_request is opaque. The value is easily available from
>>>> request->response.speed and I kind of do that already in a very ha=
ckish way.
>>>> I've sent a separate patch which adds a function that can be used =
to access
>>>> that one value.
>>>>
>>>> Waiting until the bus scan is complete isn't actually that great a=
s I
>>>> see the first LOGIN requests often before the fw_node is seen at a=
ll. I'd
>>>> have to turn away the requester and hope they try again. I'm fairl=
y sure my
>>>> little tweak in my patch is a simple enough solution.
>>>
>>>
>>> Stupid question: Could you use a completion queue or something
>>> equivalent to wait until you have seen the fw_node, *then* process =
the
>>> LOGIN request?
>>
>>
>> The fw_address_handler callback is called in interrupt context, and =
I
>> can't sleep from within there. As far as I'm aware I must call
>> fw_send_response() from within the callback and can't defer that unt=
il I've
>> scheduled something on a work queue. Please correct me if I'm wrong =
though,
>> as that might be useful anyway.
>
>
> Hmm sorry I've thought about this overnight and clearly I was talking
> rubbish. Yes, I need to reply in the fw_address_handler but all I ten=
d to do
> in there is schedule a task to the the main part of the work anyway. =
As most
> of the operations require fetching an ORB from the initiator I have t=
o do
> this from user context.
>
> So it's possible I could do this by waiting in my scheduled work func=
tion
> until the fw_node is available and get the speed from that - but that=
 seems
> like an inordinate amount of work when I can follow the standard and =
do it
> really easily by pulling it out of the fw_request.

=46air enough, I assumed that there might have been some reason why you
wouldn't have it at that point, not just convention getting in the
way.

Thanks,

--=20
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
=2EPlan: http://sites.google.com/site/juliancalaby/
