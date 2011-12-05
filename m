From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2] Add virtio-scsi to the virtio spec
Date: Mon,  5 Dec 2011 18:26:04 +0100
Message-ID: <1323105965-6391-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Rusty Russell <rusty@rustcorp.com.au>, virtualization <virtualization@lists.linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,

here is the specification for a virtio-based SCSI host (controller, HBA,
you name it).  The virtio SCSI host is the basis of an alternative
storage stack for KVM. This stack would overcome several limitations of
the current solution, virtio-blk:

1) scalability limitations: virtio-blk-over-PCI puts a strong upper
limit on the number of devices that can be added to a guest. Common
configurations have a limit of ~30 devices. While this can be worked
around by implementing a PCI-to-PCI bridge, or by using multifunction
virtio-blk devices, these solutions either have not been implemented
yet, or introduce management restrictions. On the other hand, the SCSI
architecture is well known for its scalability and virtio-scsi supports
advanced feature such as multiqueueing.

2) limited flexibility: virtio-blk does not support all possible storage
scenarios. For example, it only allows limited SCSI passthrough.
In principle, virtio-scsi provides anything that the underlying SCSI
target (be it emulated by QEMU, physical storage, iSCSI or the in-kernel
target) supports.

3) limited extensibility: over the time, many features have been added
to virtio-blk. Each such change requires modifications to the virtio
specification, to the guest drivers, and to the device model in the
host. The virtio-scsi spec has been written to follow SAM conventions,
and exposing new features to the guest will only require changes to the
host's SCSI target implementation.

This includes all the changes suggested by Hannes, Rusty and Ben in
reply to the previous version of the draft.

Here is the lyx version.  The PDF version is at
http://people.redhat.com/pbonzini/virtio-spec.pdf and the text version
of the spec (interdiff from v1) is in a reply to this message.


--- virtio-spec.lyx.saved	2011-11-29 14:00:59.782659120 +0100
+++ virtio-spec.lyx	2011-12-05 14:02:41.946266491 +0100
@@ -56,6 +56,7 @@
 \html_math_output 0
 \html_css_as_file 0
 \html_be_strict false
+\author 1531152142 "pbonzini" 
 \end_header
 
 \begin_body
@@ -321,7 +322,7 @@
 
 \begin_layout Standard
 \begin_inset Tabular
-<lyxtabular version="3" rows="8" columns="3">
+<lyxtabular version="3" rows="9" columns="3">
 <features tabularvalignment="middle">
 <column alignment="center" valignment="top" width="0">
 <column alignment="center" valignment="top" width="0">
@@ -530,6 +531,41 @@
 </cell>
 </row>
 <row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322650850
+7
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322650855
+SCSI host
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322650861
+Appendix H
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
 <cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
 \begin_inset Text
 
@@ -6427,6 +6463,2172 @@
 \end_layout
 
 \begin_layout Chapter*
+
+\change_inserted 1531152142 1322571716
+Appendix H: SCSI Host Device
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1323090161
+The virtio SCSI host device groups together one or more virtual logical
+ units (such as disks), and allows communicating to them using the SCSI
+ protocol.
+ An instance of the device represents a SCSI host to which many targets
+ and LUNs are attached.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322571726
+The virtio SCSI device services two kinds of requests:
+\end_layout
+
+\begin_layout Itemize
+
+\change_inserted 1531152142 1322571726
+command requests for a logical unit;
+\end_layout
+
+\begin_layout Itemize
+
+\change_inserted 1531152142 1322571726
+task management functions related to a logical unit, target or command.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322571726
+The device is also able to send out notifications about added and removed
+ logical units.
+ Together, these capabilities provide a SCSI transport protocol that uses
+ virtqueues as the transfer medium.
+ In the transport protocol, the virtio driver acts as the initiator, while
+ the virtio SCSI host provides one or more targets that receive and process
+ the requests.
+ 
+\end_layout
+
+\begin_layout Section*
+
+\change_inserted 1531152142 1322571697
+Configuration
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322651166
+Subsystem
+\begin_inset space ~
+\end_inset
+
+Device
+\begin_inset space ~
+\end_inset
+
+ID 7
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322571777
+Virtqueues 0:controlq; 1:eventq; 2..n:request queues.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322571813
+Feature
+\begin_inset space ~
+\end_inset
+
+bits
+\end_layout
+
+\begin_deeper
+\begin_layout Description
+
+\change_inserted 1531152142 1322653523
+VIRTIO_SCSI_F_INOUT
+\begin_inset space ~
+\end_inset
+
+(0) A single request can include both read-only and write-only data buffers.
+\end_layout
+
+\end_deeper
+\begin_layout Description
+
+\change_inserted 1531152142 1322651190
+Device
+\begin_inset space ~
+\end_inset
+
+configuration
+\begin_inset space ~
+\end_inset
+
+layout All fields of this configuration are always available.
+ 
+\series bold
+sense_size
+\series default
+ and 
+\series bold
+cdb_size
+\series default
+ are writable by the guest.
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322571919
+
+struct virtio_scsi_config {
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322575810
+
+    u32 num_queues;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322934205
+
+    u32 seg_max;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322934257
+
+    u32 max_sectors;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322934350
+
+    u32 cmd_per_lun;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322575811
+
+    u32 event_info_size;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322575811
+
+    u32 sense_size;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322575812
+
+    u32 cdb_size;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322576412
+
+    u16 max_channel;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322576413
+
+    u16 max_target;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322576414
+
+    u32 max_lun;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322571878
+
+};
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\begin_deeper
+\begin_layout Description
+
+\change_inserted 1531152142 1322724976
+num_queues is the total number of request virtqueues exposed by the device.
+ The driver is free to use only one request queue, or it can use more to
+ achieve better performance.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322934245
+seg_max is the maximum number of segments that can be in a command.
+ A bidirectional command can include 
+\series bold
+seg_max
+\series default
+ input segments and 
+\series bold
+seg_max 
+\series default
+output segments.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322934739
+max_sectors is a hint to the guest about the maximum transfer size it should
+ use.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322934845
+cmd_per_lun is a hint to the guest about the maximum number of linked commands
+ it should send to one LUN.
+ The actual value to be used is the minimum of 
+\series bold
+cmd_per_lun
+\series default
+ and the virtqueue size.
+\change_unchanged
+
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322571959
+event_info_size is the maximum size that the device will fill for buffers
+ that the driver places in the eventq.
+ The driver should always put buffers at least of this size.
+ It is written by the device depending on the set of negotated features.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322571997
+sense_size is the maximum size of the sense data that the device will write.
+ The default value is written by the device and will always be 96, but the
+ driver can modify it.
+ It is restored to the default when the device is reset.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322575599
+cdb_size is the maximum size of the CDB that the driver will write.
+ The default value is written by the device and will always be 32, but the
+ driver can likewise modify it.
+ It is restored to the default when the device is reset.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322724997
+max_channel,
+\begin_inset space \space{}
+\end_inset
+
+max_target
+\series medium
+
+\begin_inset space ~
+\end_inset
+
+and
+\begin_inset space \space{}
+\end_inset
+
+
+\series default
+max_lun can be used by the driver as hints to constrain scanning the logical
+ units on the host.
+\change_unchanged
+
+\end_layout
+
+\end_deeper
+\begin_layout Section*
+
+\change_inserted 1531152142 1322571959
+Device Initialization
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322572042
+The initialization routine should first of all discover the device's virtqueues.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322572054
+If the driver uses the eventq, it should then place at least a buffer in
+ the eventq.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322572042
+The driver can immediately issue requests (for example, INQUIRY or REPORT
+ LUNS) or task management functions (for example, I_T RESET).
+ 
+\end_layout
+
+\begin_layout Section*
+
+\change_inserted 1531152142 1322572348
+Device Operation: request queues
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322725031
+The driver queues requests to an arbitrary request queue, and they are used
+ by the device on that same queue.
+ It is the responsibility of the driver to ensure strict request ordering
+ for commands placed on different queues, because they will be consumed
+ with no order constraints.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322572395
+Requests have the following format: 
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322572526
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725766
+
+struct virtio_scsi_req_cmd {
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725783
+
+    // Read-only
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572417
+
+    u8 lun[8];
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572419
+
+    u64 id;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572420
+
+    u8 task_attr;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572422
+
+    u8 prio;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572425
+
+    u8 crn;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572426
+
+    char cdb[cdb_size];
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572410
+
+    char dataout[];
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725797
+
+    // Write-only part
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572429
+
+    u32 sense_len;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572430
+
+    u32 residual;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572432
+
+    u16 status_qualifier;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572434
+
+    u8 status;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572435
+
+    u8 response;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572437
+
+    u8 sense[sense_size];
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572439
+
+    char datain[];
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572471
+
+};
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572410
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572476
+
+/* command-specific response values */
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572480
+
+#define VIRTIO_SCSI_S_OK                0
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572483
+
+#define VIRTIO_SCSI_S_UNDERRUN          1
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572489
+
+#define VIRTIO_SCSI_S_ABORTED           2
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572491
+
+#define VIRTIO_SCSI_S_BAD_TARGET        3
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572494
+
+#define VIRTIO_SCSI_S_RESET             4
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322665324
+
+#define VIRTIO_SCSI_S_BUSY              5
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322665325
+
+#define VIRTIO_SCSI_S_TRANSPORT_FAILURE 6
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322665326
+
+#define VIRTIO_SCSI_S_TARGET_FAILURE    7
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322665326
+
+#define VIRTIO_SCSI_S_NEXUS_FAILURE     8
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322665326
+
+#define VIRTIO_SCSI_S_FAILURE           9
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572502
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572507
+
+/* task_attr */
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572510
+
+#define VIRTIO_SCSI_S_SIMPLE            0
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572513
+
+#define VIRTIO_SCSI_S_ORDERED           1
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572516
+
+#define VIRTIO_SCSI_S_HEAD              2
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322572504
+
+#define VIRTIO_SCSI_S_ACA               3
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322725062
+The 
+\series bold
+lun
+\series default
+ field addresses a target and logical unit in the virtio-scsi device's SCSI
+ domain.
+ The only supported format for the LUN field is: first byte set to 1, second
+ byte set to target, third and fourth byte representing a single level LUN
+ structure, followed by four zero bytes.
+ With this representation, a virtio-scsi device can serve up to 256 targets
+ and 16384 LUNs per target.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322572562
+The 
+\series bold
+id
+\series default
+ field is the command identifier (
+\begin_inset Quotes eld
+\end_inset
+
+tag
+\begin_inset Quotes erd
+\end_inset
+
+).
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322725122
+
+\series bold
+task_attr
+\series default
+, 
+\series bold
+prio
+\series default
+ and 
+\series bold
+crn
+\series default
+ should be left to zero.
+ 
+\series bold
+task_attr
+\series default
+ defines the task attribute as in the table above, but all task attributes
+ may be mapped to SIMPLE by the device; 
+\series bold
+crn
+\series default
+ may also be provided by clients, but is generally expected to be 0.
+ The maximum CRN value defined by the protocol is 255, since CRN is stored
+ in an 8-bit integer.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322572647
+All of these fields are defined in SAM.
+ They are always read-only, as are the 
+\series bold
+cdb
+\series default
+ and 
+\series bold
+dataout
+\series default
+ field.
+ The 
+\series bold
+cdb_size
+\series default
+ is taken from the configuration space.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322572919
+
+\series bold
+sense
+\series default
+ and subsequent fields are always write-only.
+ The 
+\series bold
+sense_len
+\series default
+ field indicates the number of bytes actually written to the sense buffer.
+ The 
+\series bold
+residual
+\series default
+ field indicates the residual size, calculated as 
+\begin_inset Quotes eld
+\end_inset
+
+data_length - number_of_transferred_bytes
+\begin_inset Quotes erd
+\end_inset
+
+, for read or write operations.
+ For bidirectional commands, the number_of_transferred_bytes includes both
+ read and written bytes.
+ A residual field that is less than the size of datain means that the dataout
+ field was processed entirely.
+ A residual field that exceeds the size of datain means that the dataout
+ field was processed partially and the datain field was not processed at
+ all.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322572971
+The 
+\series bold
+status
+\series default
+ byte is written by the device to be the status code as defined in SAM.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322572971
+The 
+\series bold
+response
+\series default
+ byte is written by the device to be one of the following:
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322572971
+VIRTIO_SCSI_S_OK when the request was completed and the status byte is filled
+ with a SCSI status code (not necessarily "GOOD").
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322572971
+VIRTIO_SCSI_S_UNDERRUN if the content of the CDB requires transferring more
+ data than is available in the data buffers.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322652973
+VIRTIO_SCSI_S_ABORTED if the request was cancelled due to an ABORT TASK
+ or ABORT TASK SET task management function.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322573041
+VIRTIO_SCSI_S_BAD_TARGET if the request was never processed because the
+ target indicated by the 
+\series bold
+lun
+\series default
+ field does not exist.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322653176
+VIRTIO_SCSI_S_RESET if the request was cancelled due to a bus or device
+ reset (including a task management function).
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322572971
+VIRTIO_SCSI_S_TRANSPORT_FAILURE if the request failed due to a problem in
+ the connection between the host and the target (severed link).
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322572971
+VIRTIO_SCSI_S_TARGET_FAILURE if the target is suffering a failure and the
+ guest should not retry on other paths.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322572971
+VIRTIO_SCSI_S_NEXUS_FAILURE if the nexus is suffering a failure but retrying
+ on other paths might yield a different result.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322664259
+VIRTIO_SCSI_S_BUSY if the request failed but retrying on the same path should
+ work.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322664258
+VIRTIO_SCSI_S_FAILURE for other host or guest error.
+ In particular, if neither dataout nor datain is empty, and the VIRTIO_SCSI_F_IN
+OUT feature has not been negotiated, the request will be immediately returned
+ with a response equal to VIRTIO_SCSI_S_FAILURE.
+ 
+\end_layout
+
+\begin_layout Section*
+
+\change_inserted 1531152142 1322573130
+Device Operation: controlq
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322573193
+The controlq is used for other SCSI transport operations.
+ Requests have the following format:
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322573233
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573243
+
+struct virtio_scsi_ctrl {
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573246
+
+    u32 type;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573248
+
+    ...
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573250
+
+    u8 response;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574229
+
+};
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574230
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574236
+
+/* response values valid for all commands */
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574310
+
+#define VIRTIO_SCSI_S_OK                       0
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322665338
+
+#define VIRTIO_SCSI_S_BAD_TARGET               3
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322665342
+
+#define VIRTIO_SCSI_S_BUSY                     5
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322665355
+
+#define VIRTIO_SCSI_S_TRANSPORT_FAILURE        6
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322665357
+
+#define VIRTIO_SCSI_S_TARGET_FAILURE           7
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322665358
+
+#define VIRTIO_SCSI_S_NEXUS_FAILURE            8
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322665359
+
+#define VIRTIO_SCSI_S_FAILURE                  9
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322665363
+
+#define VIRTIO_SCSI_S_INCORRECT_LUN            12
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322573193
+The 
+\series bold
+type
+\series default
+ identifies the remaining fields.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322573193
+The following commands are defined:
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322576973
+Task
+\begin_inset space \space{}
+\end_inset
+
+management
+\begin_inset space \space{}
+\end_inset
+
+function 
+\begin_inset space ~
+\end_inset
+
+
+\begin_inset Newline newline
+\end_inset
+
+
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+#define VIRTIO_SCSI_T_TMF                      0
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+#define VIRTIO_SCSI_T_TMF_ABORT_TASK           0
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+#define VIRTIO_SCSI_T_TMF_ABORT_TASK_SET       1
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+#define VIRTIO_SCSI_T_TMF_CLEAR_ACA            2
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+#define VIRTIO_SCSI_T_TMF_CLEAR_TASK_SET       3
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+#define VIRTIO_SCSI_T_TMF_I_T_NEXUS_RESET      4
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+#define VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET   5
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+#define VIRTIO_SCSI_T_TMF_QUERY_TASK           6
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+#define VIRTIO_SCSI_T_TMF_QUERY_TASK_SET       7
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+struct virtio_scsi_ctrl_tmf
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+{
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725821
+
+    // Read-only part
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725810
+
+    u32 type;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+    u32 subtype;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+    u8 lun[8];
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+    u64 id;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725832
+
+    // Write-only part
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+    u8 response;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+}
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+/* command-specific response values */
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322573683
+
+#define VIRTIO_SCSI_S_FUNCTION_COMPLETE        0
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322665370
+
+#define VIRTIO_SCSI_S_FUNCTION_SUCCEEDED       10
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322665370
+
+#define VIRTIO_SCSI_S_FUNCTION_REJECTED        11
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\begin_deeper
+\begin_layout Standard
+
+\change_inserted 1531152142 1322725968
+The type is VIRTIO_SCSI_T_TMF; the subtype field defines.
+ All fields except 
+\series bold
+response
+\series default
+ are filled by the driver.
+ The 
+\series bold
+subtype
+\series default
+ field must always be specified and identifies the requested task management
+ function.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322725982
+Other fields may be irrelevant for the requested TMF; if so, they are ignored
+ but they should still be present.
+ The 
+\series bold
+lun
+\series default
+ field is in the same format specified for request queues; the single level
+ LUN is ignored when the task management function addresses a whole I_T
+ nexus.
+ When relevant, the value of the 
+\series bold
+id
+\series default
+ field is matched against the id values passed on the requestq.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322574270
+The outcome of the task management function is written by the device in
+ the response field.
+ The command-specific response values map 1-to-1 with those defined in SAM.
+\end_layout
+
+\end_deeper
+\begin_layout Description
+
+\change_inserted 1531152142 1322576979
+Asynchronous
+\begin_inset space \space{}
+\end_inset
+
+notification
+\begin_inset space \space{}
+\end_inset
+
+query 
+\begin_inset space ~
+\end_inset
+
+
+\begin_inset Newline newline
+\end_inset
+
+
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574160
+
+#define VIRTIO_SCSI_T_AN_QUERY                    1
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574160
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574160
+
+struct virtio_scsi_ctrl_an {
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725848
+
+    // Read-only part
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725843
+
+    u32 type;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574160
+
+    u8  lun[8];
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574160
+
+    u32 event_requested;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725838
+
+    // Write-only part
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725838
+
+    u32 event_actual;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574160
+
+    u8  response;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574160
+
+}
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574160
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574160
+
+#define VIRTIO_SCSI_EVT_ASYNC_OPERATIONAL_CHANGE  2
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574160
+
+#define VIRTIO_SCSI_EVT_ASYNC_POWER_MGMT          4
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574160
+
+#define VIRTIO_SCSI_EVT_ASYNC_EXTERNAL_REQUEST    8
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574160
+
+#define VIRTIO_SCSI_EVT_ASYNC_MEDIA_CHANGE        16
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574160
+
+#define VIRTIO_SCSI_EVT_ASYNC_MULTI_HOST          32
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574160
+
+#define VIRTIO_SCSI_EVT_ASYNC_DEVICE_BUSY         64
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\begin_deeper
+\begin_layout Standard
+
+\change_inserted 1531152142 1322574687
+By sending this command, the driver asks the device which events the given
+ LUN can report, as described in paragraphs 6.6 and A.6 of the SCSI MMC specificat
+ion.
+ The driver writes the events it is interested in into the event_requested;
+ the device responds by writing the events that it supports into event_actual.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322574688
+The 
+\series bold
+type
+\series default
+ is VIRTIO_SCSI_T_AN_QUERY.
+ The 
+\series bold
+lun
+\series default
+ and 
+\series bold
+event_requested
+\series default
+ fields are written by the driver.
+ The 
+\series bold
+event_actual
+\series default
+ and 
+\series bold
+response
+\series default
+ fields are written by the device.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322574345
+No command-specific values are defined for the response byte.
+\end_layout
+
+\end_deeper
+\begin_layout Description
+
+\change_inserted 1531152142 1322576981
+Asynchronous
+\begin_inset space \space{}
+\end_inset
+
+notification
+\begin_inset space \space{}
+\end_inset
+
+subscription 
+\begin_inset space ~
+\end_inset
+
+
+\begin_inset Newline newline
+\end_inset
+
+
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574354
+
+#define VIRTIO_SCSI_T_AN_SUBSCRIBE                2
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574342
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574342
+
+struct virtio_scsi_ctrl_an {
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725858
+
+    // Read-only part
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574342
+
+    u32 type;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574342
+
+    u8  lun[8];
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574342
+
+    u32 event_requested;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725864
+
+    // Write-only part
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574342
+
+    u32 event_actual;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574342
+
+    u8  response;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574342
+
+}
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\begin_deeper
+\begin_layout Standard
+
+\change_inserted 1531152142 1322574708
+By sending this command, the driver asks the specified LUN to report events
+ for its physical interface, again as described in the SCSI MMC specification.
+ The driver writes the events it is interested in into the event_requested;
+ the device responds by writing the events that it supports into event_actual.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322574709
+Event types are the same as for the asynchronous notification query message.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322574710
+The 
+\series bold
+type
+\series default
+ is VIRTIO_SCSI_T_AN_SUBSCRIBE.
+ The 
+\series bold
+lun
+\series default
+ and 
+\series bold
+event_requested
+\series default
+ fields are written by the driver.
+ The 
+\series bold
+event_actual
+\series default
+ and 
+\series bold
+response
+\series default
+ fields are written by the device.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322574419
+No command-specific values are defined for the response byte.
+\end_layout
+
+\end_deeper
+\begin_layout Section*
+
+\change_inserted 1531152142 1322574433
+Device Operation: eventq
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322653610
+The eventq is used by the device to report information on logical units
+ that are attached to it.
+ The driver should always leave a few buffers ready in the eventq.
+ In general, the device will not queue events to cope with an empty eventq,
+ and will end up dropping events if it finds no buffer ready.
+ However, when reporting events for many LUNs (e.g.
+ when a whole target disappears), the device can throttle events to avoid
+ dropping them.
+ For this reason, placing 10-15 buffers on the event queue should be enough.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322574442
+Buffers are placed in the eventq and filled by the device when interesting
+ events occur.
+ The buffers should be strictly write-only (device-filled) and the size
+ of the buffers should be at least the value given in the device's configuration
+ information.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322574487
+Buffers returned by the device on the eventq will be referred to as "events"
+ in the rest of this section.
+ Events have the following format: 
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322574508
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574500
+
+#define VIRTIO_SCSI_T_EVENTS_MISSED   0x80000000
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574500
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574500
+
+struct virtio_scsi_event {
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725871
+
+    // Write-only part
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574500
+
+    u32 event;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574500
+
+    ...
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574500
+
+}
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322574516
+If bit 31 is set in the event field, the device failed to report an event
+ due to missing buffers.
+ In this case, the driver should poll the logical units for unit attention
+ conditions, and/or do whatever form of bus scan is appropriate for the
+ guest operating system.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322574521
+Other data that the device writes to the buffer depends on the contents
+ of the event field.
+ The following events are defined:
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1531152142 1322653652
+No
+\begin_inset space \space{}
+\end_inset
+
+event 
+\begin_inset space ~
+\end_inset
+
+
+\begin_inset Newline newline
+\end_inset
+
+
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574545
+
+#define VIRTIO_SCSI_T_NO_EVENT         0
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\begin_deeper
+\begin_layout Standard
+
+\change_inserted 1531152142 1322576984
+This event is fired in the following cases: 
+\end_layout
+
+\begin_layout Itemize
+
+\change_inserted 1531152142 1322574588
+When the device detects in the eventq a buffer that is shorter than what
+ is indicated in the configuration field, it might use it immediately and
+ put this dummy value in the event field.
+ A well-written driver will never observe this situation.
+\end_layout
+
+\begin_layout Itemize
+
+\change_inserted 1531152142 1322574604
+When events are dropped, the device may signal this event as soon as the
+ drivers makes a buffer available, in order to request action from the driver.
+ In this case, of course, this event will be reported with the VIRTIO_SCSI_T_EVE
+NTS_MISSED flag.
+ 
+\end_layout
+
+\end_deeper
+\begin_layout Description
+
+\change_inserted 1531152142 1322576985
+Transport
+\begin_inset space \space{}
+\end_inset
+
+reset 
+\begin_inset space ~
+\end_inset
+
+
+\begin_inset Newline newline
+\end_inset
+
+
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574628
+
+#define VIRTIO_SCSI_T_TRANSPORT_RESET  1
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574628
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725908
+
+struct virtio_scsi_event_reset {
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725876
+
+    // Write-only part
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574628
+
+    u32 event;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574628
+
+    u8  lun[8];
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574628
+
+    u32 reason;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574628
+
+}
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574628
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574628
+
+#define VIRTIO_SCSI_EVT_RESET_HARD         0
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574628
+
+#define VIRTIO_SCSI_EVT_RESET_RESCAN       1
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322574628
+
+#define VIRTIO_SCSI_EVT_RESET_REMOVED      2
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\begin_deeper
+\begin_layout Standard
+
+\change_inserted 1531152142 1322574756
+By sending this event, the device signals that a logical unit on a target
+ has been reset, including the case of a new device appearing or disappearing
+ on the bus.The device fills in all fields.
+ The 
+\series bold
+event
+\series default
+ field is set to VIRTIO_SCSI_T_TRANSPORT_RESET.
+ The 
+\series bold
+lun
+\series default
+ field addresses a logical unit in the SCSI host.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322577082
+The 
+\series bold
+reason
+\series default
+ value is one of the three #define values appearing above:
+\end_layout
+
+\begin_layout Itemize
+
+\change_inserted 1531152142 1322577449
+
+\series bold
+VIRTIO_SCSI_EVT_RESET_REMOVED
+\series default
+ (
+\begin_inset Quotes eld
+\end_inset
+
+LUN/target removed
+\begin_inset Quotes erd
+\end_inset
+
+) is used if the target or logical unit is no longer able to receive commands.
+\end_layout
+
+\begin_layout Itemize
+
+\change_inserted 1531152142 1322577452
+
+\series bold
+VIRTIO_SCSI_EVT_RESET_HARD
+\series default
+ (
+\begin_inset Quotes eld
+\end_inset
+
+LUN hard reset
+\begin_inset Quotes erd
+\end_inset
+
+) is used if the logical unit has been reset, but is still present.
+\end_layout
+
+\begin_layout Itemize
+
+\change_inserted 1531152142 1322577446
+
+\series bold
+VIRTIO_SCSI_EVT_RESET_RESCAN
+\series default
+ (
+\begin_inset Quotes eld
+\end_inset
+
+rescan LUN/target
+\begin_inset Quotes erd
+\end_inset
+
+) is used if a target or logical unit has just appeared on the device.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322577382
+The 
+\begin_inset Quotes eld
+\end_inset
+
+removed
+\begin_inset Quotes erd
+\end_inset
+
+ and 
+\begin_inset Quotes eld
+\end_inset
+
+rescan
+\begin_inset Quotes erd
+\end_inset
+
+ events, when sent for LUN 0, may apply to the entire target.
+ After receiving them the driver should ask the initiator to rescan the
+ target, in order to detect the case when an entire target has appeared
+ or disappeared.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322577057
+Events will also be reported via sense codes (this obviously does not apply
+ to newly appeared buses or targets, since the application has never discovered
+ them):
+\end_layout
+
+\begin_layout Itemize
+
+\change_inserted 1531152142 1322577457
+\begin_inset Quotes eld
+\end_inset
+
+LUN/target removed
+\begin_inset Quotes erd
+\end_inset
+
+ maps to sense key ILLEGAL REQUEST, asc 0x25, ascq 0x00 (LOGICAL UNIT NOT
+ SUPPORTED)
+\end_layout
+
+\begin_layout Itemize
+
+\change_inserted 1531152142 1322577460
+\begin_inset Quotes eld
+\end_inset
+
+LUN hard reset
+\begin_inset Quotes erd
+\end_inset
+
+ maps to sense key UNIT ATTENTION, asc 0x29 (POWER ON, RESET OR BUS DEVICE
+ RESET OCCURRED)
+\end_layout
+
+\begin_layout Itemize
+
+\change_inserted 1531152142 1322577462
+\begin_inset Quotes eld
+\end_inset
+
+rescan LUN/target
+\begin_inset Quotes erd
+\end_inset
+
+ maps to sense key UNIT ATTENTION, asc 0x3f, ascq 0x0e (REPORTED LUNS DATA
+ HAS CHANGED)
+\change_unchanged
+
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322575482
+The preferred way to detect transport reset is always to use events, because
+ sense codes are only seen by the driver when it sends a SCSI command to
+ the logical unit or target.
+ However, in case events are dropped, the initiator will still be able to
+ synchronize with the actual state of the controller if the driver asks
+ the initiator to rescan of the SCSI bus.
+ During the rescan, the initiator will be able to observe the above sense
+ codes, and it will process them as if it the driver had received the equivalent
+ event.
+ 
+\end_layout
+
+\end_deeper
+\begin_layout Description
+
+\change_inserted 1531152142 1322576987
+Asynchronous
+\begin_inset space \space{}
+\end_inset
+
+notification 
+\begin_inset space ~
+\end_inset
+
+
+\begin_inset Newline newline
+\end_inset
+
+
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322575505
+
+#define VIRTIO_SCSI_T_ASYNC_NOTIFY     2
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322575505
+
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725913
+
+struct virtio_scsi_event_an {
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322725880
+
+    // Write-only part
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322575505
+
+    u32 event;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322575505
+
+    u8  lun[8];
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322575505
+
+    u32 reason;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 1531152142 1322575505
+
+}
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\begin_deeper
+\begin_layout Standard
+
+\change_inserted 1531152142 1322575520
+By sending this event, the device signals that an asynchronous event was
+ fired from a physical interface.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322575546
+All fields are written by the device.
+ The 
+\series bold
+event
+\series default
+ field is set to VIRTIO_SCSI_T_ASYNC_NOTIFY.
+ The 
+\series bold
+lun
+\series default
+ field addresses a logical unit in the SCSI host.
+ The 
+\series bold
+reason
+\series default
+ field is a subset of the events that the driver has subscribed to via the
+ "Asynchronous notification subscription" command.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1531152142 1322575520
+When dropped events are reported, the driver should poll for asynchronous
+ events manually using SCSI commands.
+\change_unchanged
+
+\end_layout
+
+\end_deeper
+\begin_layout Chapter*
 Appendix X: virtio-mmio
 \end_layout
