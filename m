From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] virtio-scsi: hotplug suppot for virtio-scsi
Date: Mon, 02 Jul 2012 10:11:57 +0200
Message-ID: <4FF157CD.7090001@redhat.com>
References: <1340175333-16803-1-git-send-email-mc@linux.vnet.ibm.com>
	<4FF04F79.4090304@redhat.com>
	<20120702032057.Horde.WOVSk5ir309P8UvZ8oq3rUA@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20120702032057.Horde.WOVSk5ir309P8UvZ8oq3rUA@imap.linux.ibm.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: mc@linux.vnet.ibm.com
Cc: stefanha@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zwanp@cn.ibm.com, linuxram@us.ibm.com, senwang@linux.vnet.ibm.com, virtualization@lists.linux-foundation.org, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Anthony Liguori <anthony@codemonkey.ws>
List-Id: linux-scsi@vger.kernel.org

Il 02/07/2012 09:20, mc@linux.vnet.ibm.com ha scritto:
>>> +static void virtscsi_handle_event(struct work_struct *work)
>>> +{
>>> +    struct virtio_scsi_event_node *event_node =
>>> +        container_of(work, struct virtio_scsi_event_node, work);
>>> +    struct virtio_scsi *vscsi = event_node->vscsi;
>>> +    struct virtio_scsi_event *event = &event_node->event;
>>> +
>>> +    switch (event->event) {
>>> +    case VIRTIO_SCSI_T_TRANSPORT_RESET:
>>> +        virtscsi_handle_transport_reset(vscsi, event);
>>> +        break;
>>
>> Please handle VIRTIO_SCSI_T_NO_EVENT too here, and mask out
>> VIRTIO_SCSI_T_EVENTS_MISSED even if you do not handle it by triggering a
>> full rescan.
>>
> Paolo, what's the appropriate action to response VIRTIO_SCSI_T_NO_EVENT
> event? An error message?

No, just do nothing.

> I also have some confusion on VIRTIO_SCSI_T_EVENTS_MISSED:
> Should VIRTIO_SCSI_T_EVENTS_MISSED always be used with other event flag?

Yes.

> For instanse:
> (VIRTIO_SCSI_T_EVENTS_MISSED|VIRTIO_SCSI_T_TRANSPORT_RESET) is used to
> report hotplug event dropped when a buffer available.

The idea in the spec was that QEMU would report VIRTIO_SCSI_T_NO_EVENT |
VIRTIO_SCSI_T_EVENTS_MISSED as soon as a buffer becomes available, but
technically this is indeed possible.  So you need to handle
VIRTIO_SCSI_T_EVENTS_MISSED first, and the other bits separately.

Paolo
