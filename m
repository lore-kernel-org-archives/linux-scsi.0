From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 20/21] uas: Remove support for old sense ui as used in
 pre-production hardware
Date: Wed, 10 Sep 2014 16:16:21 +0200
Message-ID: <54105D35.6080707@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>	 <1410349611-17573-21-git-send-email-hdegoede@redhat.com> <1410358004.12706.29.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1410358004.12706.29.camel@linux-fkkt.site>
Sender: stable-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 09/10/2014 04:06 PM, Oliver Neukum wrote:
> On Wed, 2014-09-10 at 13:46 +0200, Hans de Goede wrote:
>> I've access to a number of different uas devices now, and none of them use
>> old style sense urbs. The only case where these code-paths trigger is with
>> the asm1051 and there they do the wrong thing, as the asm1051 sends 8 bytes
>> status iu-s when it does not have any sense data, but uses new style
>> sense iu-s regardless, as can be seen for scsi cmnds where there is sense
>> data.
> 
> This looks like a bad idea over all.

Removing this actually makes the ASM1051 bridge, which is the only one
ever sending 8 byte sense iu-s work better, as when it actually has
sense data it sends > 16 byte sense iu-s with the sense data length
at the location defined in the new 16 byte sense iu struct, and with the
old code we then ignore the length field (as we use the wrong field)
and instead use urb->actual_length - 8 bytes of the data as sense data,
while in reality there only is urb->actual_length - 16.

So either we drop support for the old style sense iu, at which point
sense iu-s just works with the ASM1051, or we need to add some extra
magic.

> The version is in the spec.

Not sure what you're trying to say here, the old sense-iu was only
ever present in draft versions. The official uas-r04.pdf and the
uas2r00.pdf draft both only define the new style 16 byte sense iu.

> And you might see true USB<->SCSI bridges passing through the
> sense data.

Right, and we support that, this just drops support for the old style
8 byte sense-iu which was only present in the r00 draft of the spec.

Regards,

Hans
