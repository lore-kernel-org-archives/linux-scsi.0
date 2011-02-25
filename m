From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH] x86: Moving probe_roms_32 to probe_roms
Date: Thu, 24 Feb 2011 17:51:03 -0800
Message-ID: <4D670B07.90005@zytor.com>
References: <20110222201538.15443.81915.stgit@localhost6.localdomain6> <AANLkTikimHCsFmavDoXn3Pka8WWMePqk+hNUK8h=DqSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikimHCsFmavDoXn3Pka8WWMePqk+hNUK8h=DqSQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, David Milburn <dmilburn@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 02/24/2011 05:27 PM, Dan Williams wrote:
> On Tue, Feb 22, 2011 at 12:16 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> From: Dave Jiang <dave.jiang@intel.com>
>>
>> Moving the probe_roms_32 code to probe_roms and make available for all x86. The
>> end result adapter roms data structure is made available read-only to drivers.
>> The Intel isci SAS driver needs to scan the OROM memory in order to pull OEM
>> parameters from the OROM.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>
>> We could just export adapter_rom_resources directly and be done with it, but
>> it seemed reasonable to have a compile time catch for drivers that try to
>> modify the resources, and that drivers should not assume the number of
>> available adapter roms.
>>
> 
> Ping?  The "RFC" was probably not needed, just wanted clarification if
> the interface for modules to retrieve the adapter rom data was in good
> taste.
> 

Rather than exporting the array -- which is functionally what you're
doing -- I would prefer if the actual probing code can be generalized
and put into probe_roms.c.  Extra bonus if it can be unified with the
existing probing code.

	-hpa
