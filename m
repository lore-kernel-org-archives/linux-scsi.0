From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCHv2 00/18] ALUA update and Referrals support
Date: Tue, 19 Nov 2013 15:42:49 -0800
Message-ID: <1384904569.4307.34.camel@haakon3.risingtidesystems.com>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384848483-3771-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hey Hannes!

On Tue, 2013-11-19 at 09:07 +0100, Hannes Reinecke wrote:
> Hi Nic,
> 
> here's the second version of my ALUA update & Referrals support patches.
> As per request I've split up the supported states into individual
> attributes, and while there I've also renamed the rather confusing
> 'alua_access_type' and 'alua_access_status' into 'alua_management_type'
> and 'alua_status_modification', respectively.
> 
> The other features are:
> 
> - Make supported states configurable:
>   We should make the list of supported ALUA states configurable,
>   as some setups would possibly like to support a small subset
>   of ALUA states only.
> - Asynchronous transitioning: I've switched 'transitioning'
>   handling to use a workqueue, that should allow us to simulate
>   asynchronous transitioning modes. IE TCM should now be capable
>   of handling requests while in transitioning, and properly terminate
>   these with the correct sense code.
> - Include target device descriptor in VPD page 83
>   For the ALUA device handler we'd need to identify the target device
>   where a given target port belongs to. So include the respective
>   values in the VPD page.
> 
> And, of course, referrals support.
> 

Ok, even though it is late, I've applied this series to for-next.

So the one main concern here is that the user visible changes to
existing ALUA configfs attributes end up breaking the lio-utils code
related to ALUA that depend upon them, which will need to be resolved
separately.

However, this breakage is pretty minor and having more sensible +
consistent attribute naming is worth the inconvenience.

--nab
