From: James.Smart@Emulex.Com
Subject: RE: bidi support: FC transport layer...
Date: Thu, 17 Jul 2008 13:25:40 -0400
Message-ID: <D1D4C3FF75F9354393DB8314DF43DEF2E7F09C@xbl3.ma.emulex.com>
References: <E11DE615-512A-45C0-9308-036BDA225E9D@qlogic.com> <D1D4C3FF75F9354393DB8314DF43DEF2E7EE27@xbl3.ma.emulex.com> <77DD6D0A-346F-4797-B05D-C3C24EAD290E@qlogic.com> <C9F1A1B1-136B-4EE0-8F64-8EE5DF04E5B6@qlogic.com> <D1D4C3FF75F9354393DB8314DF43DEF2E7EF7B@xbl3.ma.emulex.com> <B8532D23-197D-4C8E-A08C-6081DBDEE6DF@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41094 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbYGQRZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jul 2008 13:25:42 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com

Seokmann Ju wrote:
> Just for my learning, should this (FC-ping the random FC address) case
> also be covered by the implementation?

I would think this to be a great example. A small user-app that, given a
fc_host name, ping's a N_Port_ID or WWN via that port.

Assuming we create a sgio file per object :
Phase 1 : have the app could peruse the /sys/class/fc_rport/* elements
  for the fc_host, finds the one with the address or WWN, and invokes
the
  SGIO ioctl for the ELS.
Phase 2 : we deal with pinging something the hba didn't enumerate.

We would want to GPL-2 the app.

> It is not enough for 1.6 M max ports, clearly.

and I wouldn't expect it to be - and I'm not thinking about the 
FC 24 bit addr, but rather, from the system perspective, that the
sgio bits are shared by all things scsi on the system, which is SAS
and FC, etc.

> I'm just thinking that how the 32768 is small practically.

PS: I am concerned about the dev_t size, but it's not my first concern
for this api.

My concern is - this is shared by all things scsi. If you consider a
large system with say 64 adapters in it - some SAS some FC, and the
FC adapters with NPIV/VSANs, and throw in iSCSI and/or open-FCOE (it too
with vports) - and then consider that we use a bsg on every lun, on
every local SAS port, every remote SAS phy, every remote port. It would
not be hard to see a system with the equivalent of many hundred
adapters,
with say 50 or higher targets per adapter, with perhaps 16-2000 luns on
targets. At those multipliers, we easily could consume 50%, or all, of
a 32k space.  Yes, the predominant number of systems would never be
close,
but...

anyway - let's ignore this part for now.

> I see..
> There are a couple of more roles have defined in the rports besides
> FC_RPORT_ROLE_FCP_TARGET.

Um.. roles in the header file aren't what I'm talking about. FC has
a bunch of other FC4's defined.

> Overall, I guess that having a device file under the sysfs for the
> given port of the HBA should be the approach we need to pursue, then.
> And single device file per each port on the instantiated HBA is also
> be the case, I think.

Yes - we'll start with bsg dev_ts on the objects.

I'm assuming that in the fc transport, we do a bsg_register_queue()
for/under each fc_host and fc_rport created in sysfs.  Each of the 
objects will have a different request handler.

The request handler for fc_rport would contain primitives of :
  Perform ELS rqst; Perform CT rqst;

The request handler for fc_host would contain primitives of :
  <whatever we figure out for async traffic classification, buffer
   posting, etc - so we can handle recevied ELS and CT requests>
  Send ELS rsp; Send CT rsp
  
  and later:
  - Send ELS w/o login ?
  - Login to addr  (and assumes that an rport will be created for it)

We'll need to create an interface between the transport and the LLDD to
: 
- Perform an ELS; Perform a CT Request;
  Both of these referencing an rport  (note: if we didn't do it by
rport,
    it would be by fc_host and supplying an address/wwn).
  We can stop here and call it Phase 1a : e.g. we can send ELS or CT to
  a remote port and get an answer back - but, we aren't supporting
having
  the fc_host recieve an ELS/CT request and send back a response.  That
  latter part is Phase 1b, and we'll have to figure out the async
receive
  path for ELS/CT. (and no - I don't believe you can stop until you've
  completed both 1a and 1b).  We should look at the open-fcoe stack and
  make sure the interfaces are consistent - preferably the same.

- and the entry points corresponding to the fc_host primitives

- a generic bsg request handler when the request type wasn't picked off
  by the fc transport


> For the approach, following are kind of questions that came to me,
> 1. tte driver has to maintain some sort of table of
>   the all end ports, and identify one from the table with 
> some index or
>   opaque data provided by the application for a given FC-CT/ELS pkt.

I would think this just falls out of having rport structures. Should be
nothing special

> 2. Overall implementation framework should be similar to the one for
>   SMP in the SAS transport.

it will be, but the internals (e.g. send ELS/CT request) will be
different.


> I just wanted make sure that I've delivered clear communication.
> Please let me know otherwise.
> 
> And now, I've got a couple of more questions on the approach.
> 1. Should the device file created per instantiate HBA, or per port on
>   the HBA?
>     I think it should be per port base, for example, when 2-ports HBA
>   detected, we will create 2 device for the HBA.

per fc_host  - there should be a fc_host per each port.

> 2. Should we worry about the 4KB size limit?
>     I've heard that sysfs attribute has limited size of data it can
>    transport at one time and that is 4KB.

We're SGIO - so 4KB limits shouldn't matter/exist - it's not sysfs.

I have some assumptions on how the "request" is used though:
 - Whatever "control" information for the ELS or CT request should be
   passed in the "cmd" area of the request.
   I expect the FC transport to mandate something to be in the "cmd"
   area, with there minimally being a "request code".
 - Any FC-level status, such as driver generated "ELS timed out with no
   response" or BA_RJT/F_RJT/P_BSY status, etc - gets placed into the
   "sense" buffer area fo the request.
 - Transit payload is the request->bio
 - Receive payload is the request->next_rq->bio

I'm assuming we can initially live with a single bio vector from the
app.

-- james


