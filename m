From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what'smissing?
Date: Tue, 24 Jan 2012 13:13:51 -0500
Message-ID: <4F1EF4DF.2080205@redhat.com>
References: <4EF2026F.2090506@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D157077DD22B19@BLRX7MCDC203.AMER.DELL.COM> <20111222155849.GD1388@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D157077DD22D79@BLRX7MCDC203.AMER.DELL.COM> <4F0ADB0A.9020707@suse.de> <1326113987.2580.8.camel@localhost.localdomain> <D3F292ADF945FB49B35E96C94C2061B9159134BD@nsmail.netscout.com> <4F18429C.3020803@redhat.com> <D3F292ADF945FB49B35E96C94C2061B9159134EF@nsmail.netscout.com> <4F1844F0.1030406@redhat.com> <D3F292ADF945FB49B35E96C94C2061B9159135BF@nsmail.netscout.com> <4F18566A.2060107@redhat.com> <D3F292ADF945FB49B35E96C94C2061B915913815@nsmail.netscout.com> <4F188DA9.3050804@redhat.com> <D3F292ADF945FB49B35E96C94C2061B9159D00EC@nsmail.netscout.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B9159D00EC@nsmail.netscout.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: Tom Coughlan <coughlan@redhat.com>, Hannes Reinecke <hare@suse.de>, tasleson@redhat.com, Shyam_Iyer@Dell.com, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/24/2012 12:05 PM, Loke, Chetan wrote:
>>> But writes that have to fetch the non-cached data, will
> unnecessarily
>>> issue I/O to the fabric. These orphaned I/O's cause more pain in the
>>> cleanup.
>>> And if caching is enabled on the front-side then it's all the more
>>> painful.
>>>
>>> We can go one extra step and make FS fail read I/O for non-cached
> data
>>> too to avoid more orphan IOs.
>> I don't really see this as a useful state. Read-only without a real
>> backing file
>> system or LUN is hit or miss, that file system should go offline :)
>>
> Last year when I checked, I forget but I think xfs(or ext4) was going
> read-only.
> If this is still the case then you are basically asking FS's to modify
> that behavior.

Not really.

I think that at that state, we need to be able to cleanly umount those file 
systems and clean up the system without requiring a reboot.

Read-only state is not a usable condition for a file system without a backing 
device, just an side effect of our error handling...

ric

