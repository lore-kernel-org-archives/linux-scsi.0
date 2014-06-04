From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 5/6] virtio-scsi: fix various bad behavior on aborted
 requests
Date: Wed, 04 Jun 2014 21:05:15 +0200
Message-ID: <538F6DEB.2000601@redhat.com>
References: <1401881699-1456-1-git-send-email-pbonzini@redhat.com>	<1401881699-1456-6-git-send-email-pbonzini@redhat.com> <CAHdzE-8KoMrg_jSuj-F9c=HnapCiLCg9bKCifduTaxx-DAJZRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAHdzE-8KoMrg_jSuj-F9c=HnapCiLCg9bKCifduTaxx-DAJZRw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, JBottomley@parallels.com, stable@vger.kernel.org, Venkatesh Srinivas <vsrinivas@ops101.org>
List-Id: linux-scsi@vger.kernel.org

Il 04/06/2014 19:29, Venkatesh Srinivas ha scritto:
> Do you really want to poll the request VQs for completions if the TMF
> was rejected?

I wasn't sure, but bugs in this path are hard enough that I preferred 
the safer patch.

> TMF ABORT may return FUNCTION REJECTED if the command to abort
> completed before the device saw the TMF ABORT message, for example. In
> such cases, this would
> unnecessarily lengthen the EH path.

The cost of virtscsi_poll_requests should be nothing compared to the 
delay between the timeout and the invocation of the delayed_work, no?

Paolo
