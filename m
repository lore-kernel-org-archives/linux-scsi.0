From: Laurence Oberman <oberman.l@gmail.com>
Subject: Re: Persistent reservation behaviour/compliance with redundant controllers
Date: Mon, 6 Jan 2014 21:09:32 -0500
Message-ID: <5BDEBF20-8DEC-4660-A0B7-2641297E9B29@gmail.com>
References: <CAKbOo_KMG+M8F06S4wo9vta6PJjpgXzMX9ri-vr=PY0QYASPLg@mail.gmail.com> <52CB2C44.7040503@suse.com> <CAKbOo_+LxN7UN11nxrD7pQ5Evffb-jdbW9BmPJ47NWiSXG-=nQ@mail.gmail.com> <1389049579.2811.12.camel@dabdike> <CAKbOo_KzSEimm_2dRKYY+WRmLqJ1R8f6fbr5rMvyr9TDAdLF6A@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:47604 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaAGCJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2014 21:09:36 -0500
Received: by mail-qc0-f169.google.com with SMTP id r5so18671155qcx.14
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jan 2014 18:09:35 -0800 (PST)
In-Reply-To: <CAKbOo_KzSEimm_2dRKYY+WRmLqJ1R8f6fbr5rMvyr9TDAdLF6A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Eble <psychotrahe@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Lee Duncan <lduncan@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I reached out to a. Contact at HP and he shared this with. Not sure if its helpful.

3PAR does something different based on the host OS mode or Persona that is set for the host OS type being used as to how we respond with these commands. The  main aspects of this question derive with how a active/passive controller model would work, however, because 3PAR is all controllers or nodes are equal all paths are active. The 3Par implementation of S2R and S3PGR is intended to comply with SPC-3. The scope of reservations is limited to a full logical unit, element scope is not supported. SCSI-3 reservations allow each host/array path to have a key registered against it. Typically a host will register the same key upon all of the paths it sees to the array and each host will have its own unique key. Access to the volume can then be restricted to those hosts who have registered keys. 
 Should a host be determined to have gone rogue its key can be revoked by any of the still active hosts, causing the rogue host to lose access to the volume.
 
They need to register the same key to all paths of the same lun.
 
Once the host has taken appropriate action to become healthy again it can register a new key and regain access.
 
For 3PAR use the showrsv command to view things from the 3PAR array:
 
showrsv - Show information about scsi reservations of virtual volumes (VVs).
 
SYNTAX
    showrsv [options <arg>] [<VV_name>]
 
DESCRIPTION
    The showrsv command displays SCSI reservation and registration information
    for VLUNs bound for a specified port.
 
AUTHORITY
    Any role in the system
 
OPTIONS
    -l <scsi3|scsi2>

> On Jan 6, 2014, at 6:35 PM, Matthias Eble <psychotrahe@gmail.com> wrote:
> 
> 2014/1/7 James Bottomley <James.Bottomley@hansenpartnership.com>:
>>> On Mon, 2014-01-06 at 23:53 +0100, Matthias Eble wrote:
>>> 
>>> Can sdg and sdl be the same I_T_Nexus at a time?
>>> Right now, they are handled like that.
>>> In my understanding, every scsi disk device represents an I_T_Nexus.
>> 
>> No, every SCSI disk is an I_T_L nexus.  There's no actual device object
>> in Linux for an I_T nexus.
> 
> So, PR registrations are made for an I_T nexus using an I_T_L nexus.
> Probably my previous systems had a 1:1 relation between I_T and I_T_L.
> 
> Is there a way to identify which I_T_L nexuses belong to the same I_T nexus?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
