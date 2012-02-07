From: Chris Boot <bootc@bootc.net>
Subject: Re: FireWire/SBP2 Target mode
Date: Tue, 07 Feb 2012 07:38:30 +0000
Message-ID: <4F30D4F6.1040802@bootc.net>
References: <4E4BD560.4010806@bootc.net> <4E4D3B88.30003@ladisch.de> <4F29978A.3010707@redhat.com> <20120201224156.0773ebc6@stein> <4F2A55B9.4040005@panasas.com> <4F2A60DC.9030007@ladisch.de> <4F2FD1F4.9050702@bootc.net> <4F2FE705.3070509@ladisch.de> <4F2FE8DA.70502@bootc.net> <20120206212628.6880c506@stein> <5C167A1D-2203-4F1C-B538-E99DD87E7E42@bootc.net> <CAGRGNgWf0epcam-jpCzMCSqefCKDSm892mw-X49FrcoRO0QYrQ@mail.gmail.com> <476E7976-738A-4202-9FC4-FA5B060EA95F@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <476E7976-738A-4202-9FC4-FA5B060EA95F@bootc.net>
Sender: target-devel-owner@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Clemens Ladisch <clemens@ladisch.de>, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Boaz Harrosh <bharrosh@panasas.com>, Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/02/2012 23:09, Chris Boot wrote:
>
> On 6 Feb 2012, at 23:00, Julian Calaby wrote:
>
>> Hi,
>>
>> On Tue, Feb 7, 2012 at 09:28, Chris Boot<bootc@bootc.net>  wrote:
>>> On 6 Feb 2012, at 20:26, Stefan Richter wrote:
>>>
>>>> On Feb 06 Chris Boot wrote:
>>>>> On 06/02/2012 14:43, Clemens Ladisch wrote:
>>>>>> Chris Boot wrote:
>>>>>>> You can pull the code from:
>>>>>>> git://github.com/bootc/Linux-SBP-2-Target.git
>>>>>>
>>>>>> The TODO file says:
>>>>>>> * Update Juju so we can get the speed in the fw_address_handler=
 callback
>>>>>>
>>>>>> What is the speed needed for?
>>>>>
>>>>> "The speed at which the block write request to the MANAGEMENT_AGE=
NT
>>>>> register is received shall determine the speed used by the target=
 for
>>>>> all subsequent requests to read the initiator=E2=80=99s configura=
tion ROM, fetch
>>>>> ORB=E2=80=99s from initiator memory or store status at the initia=
tor=E2=80=99s
>>>>> status_FIFO. Command block ORB=E2=80=99s separately specify the s=
peed for
>>>>> requests addressed to the data buffer or page table."
>>>>>
>>>>> (T10/1155D Revision 4 page 53/54)
>>>>
>>>> I guess it is not too hard to add this to the AR-req handler.  On =
the
>>>> other hand, I see little reason to follow the SBP-2 spec to the le=
tter
>>>> here.  The target driver could just use the maximum speed that the=
 core
>>>> figured out.  On the other hand, this requires of course
>>>>   - the target to wait for core to finish scanning an initiator,
>>>>   - the core to offer an API to look up an fw_device by a
>>>>     card--generation--nodeID tuple.
>>>>
>>>> The intention of the spec is IMO clearly to enable target implemen=
tations
>>>> that do not need to implement topology scanning.  I have a hard ti=
me to
>>>> think of a valid scenario where an initiator needs to be able to s=
teer a
>>>> target towards a lower wire speed than what the participating link=
s and
>>>> PHYs actually support.
>>>
>>> The only thing stopping me from getting the speed is the fact that =
struct fw_request is opaque. The value is easily available from request=
->response.speed and I kind of do that already in a very hackish way. I=
've sent a separate patch which adds a function that can be used to acc=
ess that one value.
>>>
>>> Waiting until the bus scan is complete isn't actually that great as=
 I see the first LOGIN requests often before the fw_node is seen at all=
=2E I'd have to turn away the requester and hope they try again. I'm fa=
irly sure my little tweak in my patch is a simple enough solution.
>>
>> Stupid question: Could you use a completion queue or something
>> equivalent to wait until you have seen the fw_node, *then* process t=
he
>> LOGIN request?
>
> The fw_address_handler callback is called in interrupt context, and I=
 can't sleep from within there. As far as I'm aware I must call fw_send=
_response() from within the callback and can't defer that until I've sc=
heduled something on a work queue. Please correct me if I'm wrong thoug=
h, as that might be useful anyway.

Hmm sorry I've thought about this overnight and clearly I was talking=20
rubbish. Yes, I need to reply in the fw_address_handler but all I tend=20
to do in there is schedule a task to the the main part of the work=20
anyway. As most of the operations require fetching an ORB from the=20
initiator I have to do this from user context.

So it's possible I could do this by waiting in my scheduled work=20
function until the fw_node is available and get the speed from that -=20
but that seems like an inordinate amount of work when I can follow the=20
standard and do it really easily by pulling it out of the fw_request.

Chris

--=20
Chris Boot
bootc@bootc.net
Tel: 01271 414100
